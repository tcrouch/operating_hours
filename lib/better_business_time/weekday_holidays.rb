require 'set'

module BetterBusinessTime
  class WeekdayHolidays
    def self.set(array)
      sorted_holidays = SortedSet.new(array)
      first_holiday = sorted_holidays.min
      last_holiday = sorted_holidays.max

      count = 0
      @dates = {}

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
      add_last = get(second_date)[:holiday?] ? 1 : 0
      before(second_date) - before(first_date) + add_last
    end

    def self.before(date)
      get(date)[:holidays_before]
    end

    def self.get(date)
      @dates ||= {}
      @dates[date] || { holiday?: false, holidays_before: 0 }
    end
  end
end
