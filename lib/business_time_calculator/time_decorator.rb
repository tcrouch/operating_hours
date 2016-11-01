require 'delegate'

module BusinessTimeCalculator
  class TimeDecorator < SimpleDelegator
    def seconds_in_day
      hour * 3600 + min * 60 + sec
    end

    def workday?
      weekday? && !holiday?
    end

    def weekday?
      !weekend?
    end

    def weekend?
      saturday? || sunday?
    end

    def holiday?
      WeekdayHolidays.holiday?(self.to_date)
    end
  end
end
