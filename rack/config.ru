require_relative 'app'

app = Rack::Builder.new do
  use Rack::ContentType, "text/plain"
  map "/time" do
    run App.new
  end
end

run app
