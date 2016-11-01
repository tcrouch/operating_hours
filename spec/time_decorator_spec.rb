require 'spec_helper'

describe BusinessTimeCalculator::TimeDecorator do
  describe '#since_beginning_of_day' do
    it 'returns the number of seconds since the beginning of the day' do
      decorated = described_class.new(Time.parse('01:02:03'))
      expect(decorated.seconds_in_day).to eq(3723)
    end
  end
end
