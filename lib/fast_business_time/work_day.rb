class BusinessTimeCalculator::WorkDay
  attr_reader :times, :seconds

  def initialize(times)
    @times = times
    @seconds = times.map do |(first, last)|
      last - first
    end.inject(&:+)
  end
end
