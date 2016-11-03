class BusinessTimeCalculator
  def initialize(schedule:, holidays: [])
    @schedule = Schedule.new(schedule)
    @holidays = HolidayCollection.new(collection: holidays, schedule: @schedule)
  end

  def time_between(first_time, last_time)
    return -1 * time_between(last_time, first_time) if last_time < first_time
    schedule.seconds_in_date_range(first_time.to_date, last_time.to_date) -
      holidays.seconds_in_date_range(first_time.to_date, last_time.to_date) -
      seconds_since_beginning_of_workday(first_time) -
      seconds_until_end_of_workday(last_time)
  end

  def seconds_since_beginning_of_workday(time)
    return 0 if holiday?(time)
    schedule.seconds_since_beginning_of_day(time)
  end

  def seconds_until_end_of_workday(time)
    return 0 if holiday?(time)
    schedule.seconds_until_end_of_day(time)
  end

  def holiday?(time)
    holidays.include?(time.to_date)
  end

  private

  attr_reader :holidays, :schedule
end
