require 'amqp'
require 'json'
require 'active_support/all'

EventMachine.run do
  AMQP.connect(host: 'localhost', username: 'guest', password: 'guest') do |connection|
    puts 'Connected. Waiting for messages... Hit Control + C to stop.'

    channel  = AMQP::Channel.new(connection)

    exchange = channel.direct('newsletter-exchange', durable: true, auto_delete: false)

    channel.queue('signup-queue', durable: true, auto_delete: false).bind(exchange, routing_key: 'signup').subscribe do |metadata, payload|
      puts "message #{metadata.delivery_tag} recieved"

      puts "metadata.routing_key : #{metadata.routing_key}"
      puts "metadata.content_type: #{metadata.content_type}"
      puts "metadata.priority    : #{metadata.priority}"
      puts "metadata.headers     : #{metadata.headers.inspect}"
      puts "metadata.timestamp   : #{metadata.timestamp.inspect}"
      puts "metadata.type        : #{metadata.type}"
      puts "metadata.delivery_tag: #{metadata.delivery_tag}"
      puts "metadata.redelivered : #{metadata.redelivered}"

      puts "metadata.exchange    : #{metadata.exchange}"

      params = ActiveSupport::HashWithIndifferentAccess.new(JSON.parse(payload))

      if params[:command].present?
        if params[:command] == 'quit'
          connection.close do
            EventMachine.stop
          end
        end
      else
        if params[:signup].present?
          puts params.inspect

          # sleep to simulate a very long task
          sleep 10
        end
      end

      puts "message #{metadata.delivery_tag} processed"
    end

    stop = Proc.new do
      connection.close do
        EventMachine.stop
      end
    end

    Signal.trap('INT', &stop)
  end
end
