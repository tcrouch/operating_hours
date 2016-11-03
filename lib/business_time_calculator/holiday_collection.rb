require 'set'

class BusinessTimeCalculator::HolidayCollection
  def initialize(collection:, schedule:)
    @schedule = schedule
    @dates = calculate_holidays_time(collection)
  end

  def between(first_date, second_date)
    holidays_before(second_date + 1) - holidays_before(first_date)
  end

  def seconds_in_date_range(first_date, second_date)
    holiday_seconds_before(second_date + 1) - holiday_seconds_before(first_date)
  end

  def include?(date)
    get(date)[:holiday?]
  end

  private

  attr_reader :schedule

  def holidays_before(date)
    get(date)[:holidays_before]
  end

  def holiday_seconds_before(date)
    get(date)[:holiday_seconds_before]
  end

  def get(date)
    @dates[date] || { holiday?: false, holidays_before: 0, holiday_seconds_before: 0 }
  end

  def calculate_holidays_time(collection)
    return {} if collection.empty?

    holidays_before = 0
    holiday_seconds_before = 0

    sorted_holidays = SortedSet.new(collection)
    first_holiday = sorted_holidays.min
    last_holiday = sorted_holidays.max

    (first_holiday..last_holiday).each_with_object({}) do |date, hash|
      holiday = sorted_holidays.include?(date)
      working_seconds = schedule.seconds_per_wday(date.wday)
      hash[date] = {
        holiday?: holiday,
        holidays_before: holidays_before,
        holiday_seconds_before: holiday_seconds_before
      }
      if holiday && working_seconds > 0
        holidays_before += 1
        holiday_seconds_before += working_seconds
      end
    end
  end
end
