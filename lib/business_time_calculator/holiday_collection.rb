require 'set'

class BusinessTimeCalculator::HolidayCollection
  def initialize(array)
    count = 0
    @dates = {}

    sorted_holidays = SortedSet.new(array)
    return if sorted_holidays.empty?
    first_holiday = sorted_holidays.min
    last_holiday = sorted_holidays.max

    (first_holiday..last_holiday).each do |date|
      is_holiday = sorted_holidays.include?(date) && !date.saturday? && !date.sunday?
      @dates[date] = {
        holiday?: is_holiday,
        holidays_before: count
      }
      count += 1 if is_holiday
    end
  end

  def between(first_date, second_date)
    holidays_before(second_date + 1) - holidays_before(first_date)
  end

  def include?(date)
    get(date)[:holiday?]
  end

  private

  def holidays_before(date)
    get(date)[:holidays_before]
  end

  def get(date)
    @dates[date] || { holiday?: false, holidays_before: 0 }
  end
end
