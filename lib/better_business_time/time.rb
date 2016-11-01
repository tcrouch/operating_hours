module BetterBusinessTime
  class Time
    BEGINNING_OF_DAY = 9 * 60 * 60
    END_OF_DAY = 17 * 60 * 60
    HOURS_PER_DAY = 8 * 60 * 60

    def self.between(first_time, last_time)
      first_time = TimeDecorator.new(first_time)
      last_time = TimeDecorator.new(last_time)
      first_time.time_until_end(BEGINNING_OF_DAY, END_OF_DAY) +
        HOURS_PER_DAY * Days.between(first_time.to_date + 1, last_time.to_date) +
        last_time.time_since_beginning(BEGINNING_OF_DAY, END_OF_DAY)
    end
  end
end
