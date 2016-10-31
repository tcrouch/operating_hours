require 'rspec'
require 'date'
require_relative '../lib/better_business_time'

def date(string)
  Date.parse("#{string} 2016")
end
