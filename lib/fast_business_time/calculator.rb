module FastBusinessTime
  class Calculator
    def initialize(schedule:, holidays: [])
      @schedule = Schedule.new(schedule)
      @holidays = HolidayCollection.new(collection: holidays, schedule: @schedule)
    end

    def seconds_between_times(first_time, last_time)
      return -1 * seconds_between_times(last_time, first_time) if last_time < first_time
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

    def days_between_dates(first_date, second_date)
      return 0 if first_date == second_date
      schedule.days_in_date_range(first_date, second_date - 1) -
        holidays.days_in_date_range(first_date, second_date - 1)
    end

    def holiday?(time)
      holidays.include?(time.to_date)
    end

    def add_days_to_date(days, date)
      holiday_count = 0
      loop do
        last_date = schedule.add_days_to_date(days + holiday_count, date)
        return last_date if holiday_count == holidays.days_in_date_range(date, last_date)
        holiday_count = holidays.days_in_date_range(date, last_date)
      end
    end

    private

    attr_reader :holidays, :schedule
  end
end

