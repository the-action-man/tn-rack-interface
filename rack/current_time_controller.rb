require_relative 'time_util'

class CurrentTimeController
  START_SYMBOL_OF_QUERY_VALUE = 7.freeze

  def initialize(query)
    @query = query
    @time_util = TimeUtil.new
  end

  def call
    time(@query)
  end

  private

  def time(query)
    if query.empty? ||
      !query.start_with?("format=") ||
      query[START_SYMBOL_OF_QUERY_VALUE..].empty?
      return [400, {}, ["Time format is absent"]]
    end

    query_value = query[START_SYMBOL_OF_QUERY_VALUE..]
    time_units = query_value.split(/%../)
    error_response = @time_util.validate_time_units(time_units)
    return [400, {}, [error_response]] if error_response

    body = @time_util.formatted_time(query_value)
    [200, {}, [body]]
  end
end
