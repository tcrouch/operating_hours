module BetterBusinessTime
  class Days
    SATURDAY_WDAY = 6
    SUNDAY_WDAY = 0

    def self.between(first_date, last_date)
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
  end
end
