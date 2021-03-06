class OperatingHours::Schedule
  WDAYS = {
    sun: 0,
    mon: 1,
    tue: 2,
    wed: 3,
    thu: 4,
    fri: 5,
    sat: 6
  }

  attr_reader :seconds_per_week

  def initialize(times)
    @times = unpack_times(times)
    @seconds_per_week = @times.values.map(&:seconds).inject(&:+)
    @days_per_week = @times.keys.count
    @seconds_in_wday_ranges = calculate_seconds_in_wday_ranges
    @days_in_wday_ranges = calculate_days_in_wday_ranges
    @wdays_plus_days = calculate_wdays_plus_days
  end

  def seconds_per_wday(wday)
    day = @times[wday]
    return 0 unless day
    day.seconds
  end

  def seconds_in_date_range(first_date, second_date)
    number_of_days = (second_date - first_date + 1).to_i
    full_weeks = number_of_days / 7
    seconds = @seconds_per_week * full_weeks
    return seconds if number_of_days % 7 == 0
    seconds + @seconds_in_wday_ranges[[first_date.wday, second_date.wday]]
  end

  def days_in_date_range(first_date, second_date)
    number_of_days = (second_date - first_date + 1).to_i
    full_weeks = number_of_days / 7
    work_days = @days_per_week * full_weeks
    return work_days if number_of_days % 7 == 0
    work_days + @days_in_wday_ranges[[first_date.wday, second_date.wday]]
  end

  def seconds_since_beginning_of_day(time)
    day = @times[time.wday]
    return 0 unless day
    time_in_seconds = time_in_seconds(time)
    day.times.map do |start, _end|
      time_intersection([start, time_in_seconds], [start, _end])
    end.inject(&:+)
  end

  def seconds_until_end_of_day(time)
    day = @times[time.wday]
    return 0 unless day
    time_in_seconds = time_in_seconds(time)
    day.times.map do |start, _end|
      time_intersection([time_in_seconds, _end], [start, _end])
    end.inject(&:+)
  end

  def add_days_to_date(days, date)
    weeks = days / @days_per_week
    rest = days % @days_per_week

    date + 7 * weeks + @wdays_plus_days[[date.wday, rest]]
  end

  private

  def unpack_times(times)
    times.each_with_object({}) do |(days, day_times), hash|
      days.each do |day|
        hash[WDAYS[day]] = OperatingHours::WorkDay.new(day_times)
      end
    end
  end

  def calculate_seconds_in_wday_ranges
    (0..6).each_with_object({}) do |first_wday, hash|
      total_seconds = 0
      (0..5).each do |offset|
        second_wday = (first_wday + offset) % 7
        total_seconds += seconds_per_wday(second_wday)
        hash[[first_wday, second_wday]] = total_seconds
      end
    end
  end

  def calculate_days_in_wday_ranges
    (0..6).each_with_object({}) do |first_wday, hash|
      total_days = 0
      (0..5).each do |offset|
        second_wday = (first_wday + offset) % 7
        total_days += 1 if @times.has_key?(second_wday)
        hash[[first_wday, second_wday]] = total_days
      end
    end
  end

  def calculate_wdays_plus_days
    (0..6).each_with_object({}) do |first_wday, hash|
      calendar_days = 0
      last_wday = first_wday
      (0..@days_per_week - 1).each do |days|
        while !@times.has_key?(last_wday)
          calendar_days += 1
          last_wday = (last_wday + 1) % 7
        end
        hash[[first_wday, days]] = calendar_days
        calendar_days += 1
        last_wday = (last_wday + 1) % 7
      end
    end
  end

  def time_intersection(segment1, segment2)
    [[segment1[1], segment2[1]].min - [segment1[0], segment2[0]].max, 0].max
  end

  def time_in_seconds(time)
    time.hour * 3600 + time.min * 60 + time.sec
  end
end
