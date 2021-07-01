class ArrayFormatTimeUtil

  def initialize(query_value)
    @str = query_value
  end

  def split_to_array
    @format = []
    collect_array_format
    @format
  end

  private

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
end
