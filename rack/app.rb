require_relative 'current_time_controller'

class App
  def call(env)
    route(env)
  end

  private

  def route(env)
    req = Rack::Request.new(env)
    time_controller = CurrentTimeController.new(req.query_string)
    return time_controller.call if req.get?

    Rack::Response.new(["Use GET request for '/time'."], 404, {}).finish
  end
end
