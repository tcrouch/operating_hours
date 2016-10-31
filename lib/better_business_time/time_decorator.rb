require 'delegate'

module BetterBusinessTime
  class TimeDecorator < SimpleDelegator
    def time_until_end(beginning_of_day, end_of_day)
      return 0 if weekend?
      [end_of_day - since_beginning_of_day, 0].max -
        [beginning_of_day - since_beginning_of_day, 0].max
    end

    def time_since_beginning(beginning_of_day, end_of_day)
      return 0 if weekend?
      [since_beginning_of_day - beginning_of_day, 0].max -
        [since_beginning_of_day - end_of_day, 0].max
    end

    def since_beginning_of_day
      hour * 3600 + min * 60 + sec
    end

    def weekday?
      !weekend?
    end

    def weekend?
      saturday? || sunday?
    end
  end
end
