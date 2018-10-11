# OperatingHours

Time calculations based on business hours. Inspired by [business_time](https://github.com/bokmann/business_time) but with significantly better performance.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'operating_hours'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install operating_hours

## Usage

#### Initializiation

First initialize a calculator, a calculator needs a `schedule` and `holidays`:

```ruby
schedule = {
  [:mon, :tue, :wed, :thu, :fri] => [[9 * 3600, 17 * 3600]]
}
holidays = [Date.new(2016, 1, 1), Date.new(2016, 12, 25)]
calculator = OperatingHours::Calculator.new(schedule: schedule, holidays: holidays)

```

`schedule` is a hash whose keys are an array of weekdays and the values are an array of time intervals in seconds since the beginning of the day. So if we have a business that works on Monday 9:00-13:00, 14:00-17:30 and Tue-Fri 9:00-17:00 we would set schedule to:

````ruby
schedule = {
  [:mon] => [[9 * 3600, 13 * 3600], [14 * 3600, 17 * 3600 + 30 * 60]],
  [:tue, :wed, :thu, :fri] => [[9 * 3600, 17 * 3600]]]
}
````

`holidays` is an array of dates, you could probably use the [holiday gem](https://github.com/holidays/holidays)

It's recommended to memoize the calculators, so you could do:

````ruby
class TimeCalculators
  def self.ny
	@ny ||= OperatingHours::Calculator.new(
	          schedule: [:mon, :tue, :wed, :thu, :fri] => [[9 * 3600, 17 * 3600]],
	          holidays: [Date.new(2016, 1, 1), Date.new(2016, 12, 25)]
	        )
  end

  def self.sf
  	@sf ||= OperatingHours::Calculator.new(
	          schedule: [:mon, :tue, :wed, :thu, :fri] => [[9 * 3600, 18 * 3600]],
	          holidays: [Date.new(2016, 1, 1), Date.new(2016, 12, 25)]
	        )
  end
end
````

#### Methods

* `calculator.seconds_between_times(time1, time2)`: (Integer) Working seconds between two times.
* `calculator.days_between_dates(date1, date2)`: (Integer) Number of work days between two dates (excluding edges).
* `calculator.seconds_since_beginning_of_workday(time)`: (Integer) Working seconds since workday started.
* `calculator.seconds_until_end_of_workday(time)`: (Integer) Working seconds until workday finishes.
* `calculator.holiday?(time_or_date)`: (Boolean) Whether time or date is a holiday.
* `calculator.add_days_to_date(days, date)`: (Date) Adds given work days to a date.


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/spreemo/operating_hours. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

Copyright (c) 2016 Spreemo. The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
