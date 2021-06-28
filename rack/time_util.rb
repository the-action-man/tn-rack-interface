class TimeUtil
  AVAILABLE_TIME_UNITS =
    {
      "year" => "Y",
      "month" => "m",
      "day" => "d",
      "hour" => "H",
      "minute" => "M",
      "second" => "S",
    }.freeze

  def validate_time_units(units)
    unknown_formats = []
    units.each do |unit|
      unknown_formats << unit unless AVAILABLE_TIME_UNITS.keys.include?(unit)
    end
    return if unknown_formats.empty?

    "Unknown time format #{unknown_formats}"
  end

  def formatted_time(query_value)
    array_format = split_to_array_format(query_value)
    format = ruby_format_string(array_format)
    Time.now.strftime(format)
  end

  def split_to_array_format(query_value)
    @str = query_value
    @format = []
    collect_array_format
    @format
  end

  def collect_array_format
    unit_separator_index = find_unit_separator_index
    while unit_separator_index do
      add_unit_before_separator(unit_separator_index)
      add_unit_separator
      unit_separator_index = find_unit_separator_index
    end
    @format << @str
  end

  def find_unit_separator_index
    @str.index("%")
  end

  def add_unit_before_separator(index)
    @format << @str[0..index - 1]
    @str = @str[index..]
  end

  def add_unit_separator
    @format << @str[0..2]
    @str = @str[3..]
  end

  def ruby_format_string(abnormal_format)
    abnormal_format.map do |item|
      if item.start_with?("%")
        URI.unescape(item)
      else
        "%#{AVAILABLE_TIME_UNITS[item]}"
      end
    end.join("")
  end
end


