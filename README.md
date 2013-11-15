# Unicorn + Sinatra + AMQP

Just a simple demo showing how to do a Sinatra application running on Unicorn that uses AMQP as a job queue.

## Development

### Starting the Web Server

    $ unicorn -c unicorn.conf -E development

### Staring the AMQP Worker

    $ bin/amqp_worker

## Deployment

This project uses Capistrano for deployment. Currently it's set up so that it'll be deployed to a virtual machine running CentOS.

## Helpful Reading

* http://rubyamqp.info/articles/patterns_and_use_cases/
* https://github.com/p8952/nginx-unicorn-sinatra
* http://recipes.sinatrarb.com/p/deployment/nginx_proxied_to_unicorn
* https://github.com/matiaskorhonen/thin-amqp-sinatra
* https://github.com/rabbitinaction/sourcecode/tree/master/ruby/chapter-2
* http://rubyamqp.info/articles/connecting_to_broker/#toc_15
