class BusinessTimeCalculator
  BEGINNING_OF_DAY = 9 * 60 * 60
  END_OF_DAY = 17 * 60 * 60
  HOURS_PER_DAY = 8 * 60 * 60
  SATURDAY_WDAY = 6
  SUNDAY_WDAY = 0

  def self.between(first_time, last_time)
    return -1 * between(last_time, first_time) if last_time < first_time
    first_time = TimeDecorator.new(first_time)
    last_time = TimeDecorator.new(last_time)
    HOURS_PER_DAY * days_between(first_time.to_date, last_time.to_date) -
      business_time_before(first_time) -
      business_time_after(last_time)
  end

  def self.days_between(first_date, last_date)
    calendar_days_between(first_date, last_date) -
      weekend_days_between(first_date, last_date) -
      WeekdayHolidays.between(first_date, last_date)
  end

  def self.calendar_days_between(first_date, last_date)
    (last_date - first_date).to_i + 1
  end

  def self.weekend_days_between(first_date, last_date)
    full_weeks = calendar_days_between(first_date, last_date) / 7
    shifted_date = first_date + full_weeks * 7
    weekend_days = full_weeks * 2
    next_saturday = shifted_date + ((SATURDAY_WDAY - shifted_date.wday) % 7)
    next_sunday = shifted_date + ((SUNDAY_WDAY - shifted_date.wday) % 7)
    weekend_days += 1 if next_saturday <= last_date
    weekend_days += 1 if next_sunday <= last_date
    weekend_days
  end

  def self.business_time_before(time)
    return 0 if !time.workday?

    time_intersection([BEGINNING_OF_DAY, time.seconds_in_day], [BEGINNING_OF_DAY, END_OF_DAY])
  end

  def self.business_time_after(time)
    return 0 if !time.workday?

    time_intersection([time.seconds_in_day, END_OF_DAY], [BEGINNING_OF_DAY, END_OF_DAY])
  end

  def self.time_intersection(segment1, segment2)
    [[segment1[1], segment2[1]].min - [segment1[0], segment2[0]].max, 0].max
  end
end
