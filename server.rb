class Server < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  configure :development, :production do
    enable :logging

    file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')

    file.sync = true

    use Rack::CommonLogger, file
  end

  register Sinatra::ConfigFile

  config_file 'config/settings.yml'

  get '/' do
    erb :index
  end

  post '/signup' do
    if params[:signup].present?
      EventMachine.next_tick do
        AMQP.connect(host: 'localhost', username: 'guest', password: 'guest') do |connection|
          channel = AMQP::Channel.new(connection)

          payload = { signup: params[:signup] }

          channel.direct('newsletter-exchange', durable: true, auto_delete: false).publish(payload.to_json, routing_key: 'signup')
        end
      end

      erb :thanks
    else
      erb '404', layout: false
    end
  end

  not_found do
    erb '404', layout: false
  end

  helpers do
    def partial(template, locals = nil)
      locals = locals.is_a?(Hash) ? locals : { template.to_sym => locals }

      template = ('_' + template.to_s).to_sym

      erb template, { layout: false }, locals
    end

    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    end
  end

  run! if app_file == $0
end
