ENV['FORKING'] = 'true'

listen 9292

worker_processes 1
timeout          30

preload_app true

after_fork do |server, worker|
  require 'amqp'
  require 'json'

  Thread.new do
    AMQP.start
  end

  sleep(1.0)

  EventMachine.next_tick do
    AMQP.channel ||= AMQP::Channel.new(AMQP.connection)

    AMQP.channel.queue('signup-queue', durable: true)

    3.times do |i|
      puts "[after_fork/amqp] Publishing a warmup message ##{i}"

      payload = { message: "Warmup message #{i}, sent at #{Time.now.to_s}" }

      AMQP.channel.default_exchange.publish(payload.to_json, routing_key: 'signup')
    end
  end
end
