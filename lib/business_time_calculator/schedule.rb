class BusinessTimeCalculator::Schedule
  attr_reader :hours_per_day

  def initialize(schedule = {})
    @beginning_of_day = schedule[:beginning_of_day] || 9 * 60 * 60
    @end_of_day = schedule[:end_of_day] || 17 * 60 * 60
    @hours_per_day = @end_of_day - @beginning_of_day
  end

  def time_before(time)
    time_in_seconds = seconds_in_day(time)
    time_intersection([beginning_of_day, time_in_seconds], [beginning_of_day, end_of_day])
  end

  def time_after(time)
    time_in_seconds = seconds_in_day(time)
    time_intersection([time_in_seconds, end_of_day], [beginning_of_day, end_of_day])
  end

  private

  attr_reader :beginning_of_day, :end_of_day

  def time_intersection(segment1, segment2)
    [[segment1[1], segment2[1]].min - [segment1[0], segment2[0]].max, 0].max
  end

  def seconds_in_day(time)
    time.hour * 3600 + time.min * 60 + time.sec
  end
end
