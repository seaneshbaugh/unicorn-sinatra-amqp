# Unicorn + Sinatra + AMQP

Just a simple demo showing how to do a Sinatra application running on Unicorn that uses AMQP as a job queue.

# Starting the Web Server

    $ unicorn -c unicorn.rb -E development

# Staring the AMQP Worker

    $ ruby amqp_worker.rb
