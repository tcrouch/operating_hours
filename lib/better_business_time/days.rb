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
      return 0 if first_date == last_date
      (last_date - first_date).to_i - 1
    end

    def self.weekend_days_between(first_date, last_date)
      full_weeks = calendar_days_between(first_date, last_date) / 7
      weekend_days = full_weeks * 2
      first_wday = first_date.wday
      last_wday = last_date.wday
      return weekend_days if first_wday <= last_wday
      weekend_days += 1 if first_wday < SATURDAY_WDAY
      weekend_days += 1 if last_wday > SUNDAY_WDAY
      weekend_days
    end
  end
end
