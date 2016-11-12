require 'rspec'
require 'date'
require 'time'
require 'pry'

require_relative '../lib/business_time_calculator'

def d(string)
  check_weekday(string) do
    Date.parse("#{string} 2016")
  end
end

def t(date_string, time_string)
  check_weekday(date_string) do
    Time.parse("#{date_string} 2016 #{time_string}")
  end
end

def check_weekday(string)
  wday_word = string.split(' ')[0].to_s.downcase
  wday = BusinessTimeCalculator::Schedule::WDAYS[wday_word]
  date_or_time = yield
  if wday && date_or_time.wday != wday
    raise 'Wrong weekday entered'
  end
  date_or_time
end
