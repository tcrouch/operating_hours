require 'rspec'
require 'date'
require 'time'
require 'pry'

require_relative '../lib/better_business_time'

def d(string)
  Date.parse("#{string} 2016")
end

def t(date_string, time_string)
  Time.parse("#{date_string} 2016 #{time_string}")
end

RSpec.configure do |config|
  config.before do
    BetterBusinessTime::WeekdayHolidays.set([])
  end
end
