class BusinessTimeCalculator
  SATURDAY_WDAY = 6
  SUNDAY_WDAY = 0

  def initialize(schedule:, holidays: [])
    @schedule = Schedule.new(schedule)
    @holidays = HolidayCollection.new(holidays)
  end

  def time_between(first_time, last_time)
    return -1 * time_between(last_time, first_time) if last_time < first_time
    schedule.hours_per_day * days_between(first_time.to_date, last_time.to_date) -
      business_time_before(first_time) -
      business_time_after(last_time)
  end

  def days_between(first_date, last_date)
    calendar_days_between(first_date, last_date) -
      weekend_days_between(first_date, last_date) -
      holidays.between(first_date, last_date)
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
    schedule.time_before(time)
  end

  def business_time_after(time)
    return 0 if !workday?(time)
    schedule.time_after(time)
  end

  def workday?(time)
    !time.saturday? && !time.sunday? && !holiday?(time)
  end

  def holiday?(time)
    holidays.include?(time.to_date)
  end

  private

  attr_reader :holidays, :schedule
end
