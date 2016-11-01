require 'set'

class BusinessTimeCalculator::WeekdayHolidays
  def self.set(array)
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

  def self.between(first_date, second_date)
    before(second_date + 1) - before(first_date)
  end

  def self.before(date)
    get(date)[:holidays_before]
  end

  def self.holiday?(date)
    get(date)[:holiday?]
  end

  def self.get(date)
    @dates ||= {}
    @dates[date] || { holiday?: false, holidays_before: 0 }
  end
end
