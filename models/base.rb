class Base
  def initialize(data)
    @data = data
  end

  def method_missing(m)
    return @data[m] if @data.keys.include?(m)
    super
  end
end
