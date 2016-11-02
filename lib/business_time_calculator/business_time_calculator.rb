class BusinessTimeCalculator
  SATURDAY_WDAY = 6
  SUNDAY_WDAY = 0

  attr_reader :beginning_of_day, :end_of_day, :hours_per_day

  def initialize(settings = {})
    @beginning_of_day = settings[:beginning_of_day] || 9 * 60 * 60
    @end_of_day = settings[:end_of_day] || 17 * 60 * 60
    @hours_per_day = @end_of_day - @beginning_of_day
  end

  def between(first_time, last_time)
    return -1 * between(last_time, first_time) if last_time < first_time
    hours_per_day * days_between(first_time.to_date, last_time.to_date) -
      business_time_before(first_time) -
      business_time_after(last_time)
  end

  def days_between(first_date, last_date)
    calendar_days_between(first_date, last_date) -
      weekend_days_between(first_date, last_date) -
      HolidayCollection.between(first_date, last_date)
  end

  def calendar_days_between(first_date, last_date)
    (last_date - first_date).to_i + 1
  end

  def weekend_days_between(first_date, last_date)
    full_weeks = calendar_days_between(first_date, last_date) / 7
    shifted_date = first_date + full_weeks * 7
    weekend_days = full_weeks * 2
    next_saturday = shifted_date + ((SATURDAY_WDAY - shifted_date.wday) % 7)
    next_sunday = shifted_date + ((SUNDAY_WDAY - shifted_date.wday) % 7)
    weekend_days += 1 if next_saturday <= last_date
    weekend_days += 1 if next_sunday <= last_date
    weekend_days
  end

  def business_time_before(time)
    return 0 if !workday?(time)

    seconds_in_day = seconds_in_day(time)
    time_intersection([beginning_of_day, seconds_in_day], [beginning_of_day, end_of_day])
  end

  def business_time_after(time)
    return 0 if !workday?(time)

    seconds_in_day = seconds_in_day(time)
    time_intersection([seconds_in_day, end_of_day], [beginning_of_day, end_of_day])
  end

  def time_intersection(segment1, segment2)
    [[segment1[1], segment2[1]].min - [segment1[0], segment2[0]].max, 0].max
  end

  def workday?(time)
    !time.saturday? && !time.sunday? && !holiday?(time)
  end

  def holiday?(time)
    BusinessTimeCalculator::HolidayCollection.holiday?(time.to_date)
  end

  private

  def seconds_in_day(time)
    time.hour * 3600 + time.min * 60 + time.sec
  end
end
