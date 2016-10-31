module BetterBusinessTime
  class Days
    def self.between(first_date, last_date)
      calendar_days_between(first_date, last_date) -
        weekend_days_between(first_date, last_date) -
        WeekdayHolidays.between(first_date, last_date)
    end

    def self.calendar_days_between(first_date, last_date)
      (last_date - first_date).to_i
    end

    def self.weekend_days_between(first_date, last_date)
      full_weeks = calendar_days_between(first_date, last_date) / 7
      weekend_days = full_weeks * 2
      first_wday = first_date.wday
      second_wday = last_date.wday
      return weekend_days if first_wday == second_wday
      return weekend_days + 2 if first_wday > second_wday
      weekend_days += 1 if first_date.saturday? || first_date.sunday?
      weekend_days += 1 if last_date.saturday? || last_date.sunday?
      weekend_days
    end
  end
end
