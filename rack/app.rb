# require_relative 'time'
# require_relative 'headers'

# require 'time'
# require 'headers'

class App
  def call(env)
    route(env)
  end

  private

  def route(env)
    req = Rack::Request.new(env)
    time = Time.new(req.query_string)

    return time.call if req.path == ("/time") && req.get?

    Rack::Response.new(["oops"], 404, headers).finish
  end

  def headers
    # { 'Content-Type' => 'text/plain' }
    Headers::HEADERS
  end
end
