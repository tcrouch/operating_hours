require 'spec_helper'

describe BetterBusinessTime::TimeDecorator do
  describe '#since_beginning_of_day' do
    it 'returns the number of seconds since the beginning of the day' do
      decorated = described_class.new(Time.parse('01:02:03'))
      expect(decorated.since_beginning_of_day).to eq(3723)
    end
  end

  describe '#time_until_end' do
    def described_method(*args)
      described_class.time_until_end(*args)
    end

    it 'returns 8 hours before beginning of day' do
      decorated = described_class.new(t('Mon Oct 31', '08:59:59'))
      expect(decorated.time_until_end(9 * 3600, 17 * 3600)).to eq(8 * 3600)
    end

    it 'returns 0 hours after end of day' do
      decorated = described_class.new(t('Mon Oct 31', '17:00:01'))
      expect(decorated.time_until_end(9 * 3600, 17 * 3600)).to eq(0)
    end

    it 'returns number of hours before end of day' do
      decorated = described_class.new(t('Mon Oct 31', '10:59:59'))
      expect(decorated.time_until_end(9 * 3600, 17 * 3600)).to eq(6 * 3600 + 1)
    end

    it 'returns 0 on weekends' do
      decorated = described_class.new(t('Sun Oct 30', '10:59:59'))
      expect(decorated.time_until_end(9 * 3600, 17 * 3600)).to eq(0)
    end
  end

  describe '#time_since_beginning' do
    def described_method(*args)
      described_class.time_since_beginning(*args)
    end

    it 'returns 0 hours before beginning of day' do
      decorated = described_class.new(t('Mon Oct 31', '08:59:59'))
      expect(decorated.time_since_beginning(9 * 3600, 17 * 3600)).to eq(0)
    end

    it 'returns 8 hours after end of day' do
      decorated = described_class.new(t('Mon Oct 31', '17:00:01'))
      expect(decorated.time_since_beginning(9 * 3600, 17 * 3600)).to eq(8 * 3600)
    end

    it 'returns number of hours since beginning' do
      decorated = described_class.new(t('Mon Oct 31', '11:00:01'))
      expect(decorated.time_since_beginning(9 * 3600, 17 * 3600)).to eq(7201)
    end

    it 'returns 0 on weekends' do
      decorated = described_class.new(t('Sun Oct 30', '10:59:59'))
      expect(decorated.time_since_beginning(9 * 3600, 17 * 3600)).to eq(0)
    end
  end
end
