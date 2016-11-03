class BusinessTimeCalculator::Schedule
  attr_reader :hours_per_day, :seconds_per_week

  WDAYS = {
    sun: 0,
    mon: 1,
    tue: 2,
    wed: 3,
    thu: 4,
    fri: 5,
    sat: 6
  }

  def initialize(times)
    @times = unpack_times(times)
    @seconds_per_week = @times.values.map(&:seconds).inject(&:+)
    @hours_per_day = 8 * 3600
  end

  def seconds_per_day(wday)
    day = @times[wday]
    return 0 unless day
    day.seconds
  end

  def time_before(time)
    day = @times[time.wday]
    return 0 unless day
    time_in_seconds = seconds_in_day(time)
    day.times.map do |start, _end|
      time_intersection([start, time_in_seconds], [start, _end])
    end.inject(&:+)
  end

  def time_after(time)
    day = @times[time.wday]
    return 0 unless day
    time_in_seconds = seconds_in_day(time)
    day.times.map do |start, _end|
      time_intersection([time_in_seconds, _end], [start, _end])
    end.inject(&:+)
  end

  private

  attr_reader :beginning_of_day, :end_of_day

  def unpack_times(times)
    hash = {}
    times.each do |days, day_times|
      days.each do |day|
        hash[WDAYS[day]] = BusinessTimeCalculator::WorkDay.new(day_times)
      end
    end
    hash
  end

  def time_intersection(segment1, segment2)
    [[segment1[1], segment2[1]].min - [segment1[0], segment2[0]].max, 0].max
  end

  def seconds_in_day(time)
    time.hour * 3600 + time.min * 60 + time.sec
  end
end
