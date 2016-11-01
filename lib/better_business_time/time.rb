module BetterBusinessTime
  class Time
    BEGINNING_OF_DAY = 9 * 60 * 60
    END_OF_DAY = 17 * 60 * 60
    HOURS_PER_DAY = 8 * 60 * 60

    def self.between(first_time, last_time)
      return -1 * between(last_time, first_time) if last_time < first_time
      first_time = TimeDecorator.new(first_time)
      last_time = TimeDecorator.new(last_time)
      if first_time.to_date == last_time.to_date
        return 0 if !first_time.workday?
        segment_intersection([first_time, last_time], [BEGINNING_OF_DAY, END_OF_DAY])
      else
        HOURS_PER_DAY * Days.between(first_time.to_date, last_time.to_date) -
          business_time_before(first_time) -
          business_time_after(last_time)
      end
    end

    def self.segment_intersection(segment1, segment2)
      x_0 = segment1[0].is_a?(Numeric) ? segment1[0] : segment1[0].since_beginning_of_day
      x_1 = segment1[1].is_a?(Numeric) ? segment1[1] : segment1[1].since_beginning_of_day
      y_0 = segment2[0].is_a?(Numeric) ? segment2[0] : segment2[0].since_beginning_of_day
      y_1 = segment2[1].is_a?(Numeric) ? segment2[1] : segment2[1].since_beginning_of_day

      [[x_1, y_1].min - [x_0, y_0].max, 0].max
    end

    def self.business_time_before(time)
      return 0 if !time.workday?

      segment_intersection([BEGINNING_OF_DAY, time.since_beginning_of_day], [BEGINNING_OF_DAY, END_OF_DAY])
    end

    def self.business_time_after(time)
      return 0 if !time.workday?

      segment_intersection([time.since_beginning_of_day, END_OF_DAY], [BEGINNING_OF_DAY, END_OF_DAY])
    end
  end
end
