require 'rspec'
require 'date'
require 'time'
require 'pry'

require_relative '../lib/business_time_calculator'

def d(string)
  Date.parse("#{string} 2016")
end

def t(date_string, time_string)
  Time.parse("#{date_string} 2016 #{time_string}")
end

RSpec.configure do |config|
  config.before do
    BusinessTimeCalculator::HolidayCollection.set([])
  end
end
