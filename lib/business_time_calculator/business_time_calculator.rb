class BusinessTimeCalculator
  def initialize(schedule:, holidays: [])
    @schedule = Schedule.new(schedule)
    @holidays = HolidayCollection.new(holidays)
  end

  def time_between(first_time, last_time)
    return -1 * time_between(last_time, first_time) if last_time < first_time
    schedule.seconds_in_date_range(first_time.to_date, last_time.to_date) -
      schedule.hours_per_day * holidays.between(first_time.to_date, last_time.to_date) -
      business_time_before(first_time) -
      business_time_after(last_time)
  end

  def business_time_before(time)
    return 0 if holiday?(time)
    schedule.time_before(time)
  end

  def business_time_after(time)
    return 0 if holiday?(time)
    schedule.time_after(time)
  end

  def holiday?(time)
    holidays.include?(time.to_date)
  end

  private

  attr_reader :holidays, :schedule
end
