require 'spec_helper'

describe BusinessTimeCalculator::Schedule do
  describe '.time_before' do
    def time_before(*args)
      described_class.new.time_before(*args)
    end

    it 'returns the working time in seconds before given time' do
      expect(time_before(Time.parse('8:59'))).to eq(0)
      expect(time_before(Time.parse('10:00'))).to eq(3600)
      expect(time_before(Time.parse('16:00'))).to eq(7 * 3600)
      expect(time_before(Time.parse('19:00'))).to eq(8 * 3600)
    end
  end

  describe '.time_after' do
    def time_after(*args)
      described_class.new.time_after(*args)
    end

    it 'returns the working time in after before given time' do
      expect(time_after(Time.parse('8:59'))).to eq(8 * 3600)
      expect(time_after(Time.parse('10:00'))).to eq(7 * 3600)
      expect(time_after(Time.parse('16:00'))).to eq(3600)
      expect(time_after(Time.parse('19:00'))).to eq(0)
    end
  end
end
