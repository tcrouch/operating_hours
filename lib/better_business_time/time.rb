module BetterBusinessTime
  class Time
    BEGINNING_OF_DAY = 9 * 60 * 60
    END_OF_DAY = 17 * 60 * 60
    HOURS_PER_DAY = 8 * 60 * 60

    def self.between(first_time, last_time)
      first_time = TimeDecorator.new(first_time)
      last_time = TimeDecorator.new(last_time)
      if first_time.to_date == last_time.to_date
        return 0 if !first_time.workday?
        segment_intersection([first_time, last_time], [BEGINNING_OF_DAY, END_OF_DAY])
      else
        first_time.time_until_end(BEGINNING_OF_DAY, END_OF_DAY) +
          HOURS_PER_DAY * Days.between(first_time.to_date, last_time.to_date) +
          last_time.time_since_beginning(BEGINNING_OF_DAY, END_OF_DAY)
      end
    end

    def self.segment_intersection(segment1, segment2)
      x_0 = segment1[0].is_a?(Numeric) ? segment1[0] : segment1[0].since_beginning_of_day
      x_1 = segment1[1].is_a?(Numeric) ? segment1[1] : segment1[1].since_beginning_of_day
      y_0 = segment2[0].is_a?(Numeric) ? segment2[0] : segment2[0].since_beginning_of_day
      y_1 = segment2[1].is_a?(Numeric) ? segment2[1] : segment2[1].since_beginning_of_day

      [[x_1, y_1].min - [x_0, y_0].max, 0].max
    end
  end
end
