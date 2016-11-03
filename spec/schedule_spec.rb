require 'spec_helper'

describe BusinessTimeCalculator::Schedule do
  describe '#seconds_per_week' do
    it 'returns the total seconds in a week' do
      options = { [:mon, :tue, :wed, :thu, :fri] => [[9 * 3600, 17 * 3600]] }
      expect(described_class.new(options).seconds_per_week).to eq(40 * 3600)

      options = {
        [:mon, :tue, :wed, :thu, :fri] => [[9 * 3600, 13 * 3600], [14 * 3600, 17 * 3600]],
        [:sat] => [[10 * 3600, 14 * 3600]]
      }
      expect(described_class.new(options).seconds_per_week).to eq(39 * 3600)
    end
  end

  describe '#seconds_per_day' do
    it 'returns the seconds in a given day' do
      options = {
        [:mon] => [[9 * 3600, 17 * 3600]],
        [:tue, :wed] => [[9 * 3600, 13 * 3600], [14 * 3600, 17 * 3600]],
        [:thu] => [[9 * 3600, 18 * 3600]],
        [:fri] => [[9 * 3600, 15 * 3600]],
      }
      schedule = described_class.new(options)

      expect(schedule.seconds_per_day(0)).to eq(0)
      expect(schedule.seconds_per_day(1)).to eq(8 * 3600)
      expect(schedule.seconds_per_day(2)).to eq(7 * 3600)
      expect(schedule.seconds_per_day(3)).to eq(7 * 3600)
      expect(schedule.seconds_per_day(4)).to eq(9 * 3600)
      expect(schedule.seconds_per_day(5)).to eq(6 * 3600)
      expect(schedule.seconds_per_day(6)).to eq(0 * 3600)
    end
  end

  describe '#time_before' do
    def time_before(*args)
      options = {
        [:mon] => [[9 * 3600, 17 * 3600]],
        [:tue, :thu] => [[9 * 3600, 13 * 3600], [14 * 3600, 20 * 3600]],
        [:wed] => [[9 * 3600, 18 * 3600]],
        [:fri] => [[8 * 3600, 16 * 3600]],
        [:sat] => [[10 * 3600, 14 * 3600]]
      }

      described_class.new(options).time_before(*args)
    end

    it 'returns the working time in seconds before given time' do
      expect(time_before(t('Mon Oct 31', '8:59'))).to eq(0)
      expect(time_before(t('Mon Oct 31', '10:00'))).to eq(3600)
      expect(time_before(t('Mon Oct 31', '16:00'))).to eq(7 * 3600)
      expect(time_before(t('Mon Oct 31', '19:00'))).to eq(8 * 3600)

      expect(time_before(t('Tue Nov 1', '8:59'))).to eq(0)
      expect(time_before(t('Tue Nov 1', '10:00'))).to eq(3600)
      expect(time_before(t('Tue Nov 1', '16:00'))).to eq(6 * 3600)
      expect(time_before(t('Tue Nov 1', '19:00'))).to eq(9 * 3600)
      expect(time_before(t('Tue Nov 1', '20:00'))).to eq(10 * 3600)

      expect(time_before(t('Wed Nov 2', '8:59'))).to eq(0)
      expect(time_before(t('Wed Nov 2', '10:00'))).to eq(3600)
      expect(time_before(t('Wed Nov 2', '16:00'))).to eq(7 * 3600)
      expect(time_before(t('Wed Nov 2', '19:00'))).to eq(9 * 3600)

      expect(time_before(t('Thu Nov 3', '8:59'))).to eq(0)
      expect(time_before(t('Thu Nov 3', '10:00'))).to eq(3600)
      expect(time_before(t('Thu Nov 3', '16:00'))).to eq(6 * 3600)
      expect(time_before(t('Thu Nov 3', '19:00'))).to eq(9 * 3600)
      expect(time_before(t('Thu Nov 3', '20:00'))).to eq(10 * 3600)

      expect(time_before(t('Fri Nov 4', '8:59'))).to eq(59 * 60)
      expect(time_before(t('Fri Nov 4', '10:00'))).to eq(2 * 3600)
      expect(time_before(t('Fri Nov 4', '16:00'))).to eq(8 * 3600)
      expect(time_before(t('Fri Nov 4', '19:00'))).to eq(8 * 3600)

      expect(time_before(t('Sat Nov 5', '10:00'))).to eq(0)
      expect(time_before(t('Sat Nov 5', '16:00'))).to eq(4 * 3600)
      expect(time_before(t('Sat Nov 5', '19:00'))).to eq(4 * 3600)

      expect(time_before(t('Sun Nov 6', '12:00'))).to eq(0)
      expect(time_before(t('Sun Nov 6', '19:00'))).to eq(0)
    end
  end

  describe '#time_after' do
    def time_after(*args)
      options = {
        [:mon] => [[9 * 3600, 17 * 3600]],
        [:tue, :thu] => [[9 * 3600, 13 * 3600], [14 * 3600, 20 * 3600]],
        [:wed] => [[9 * 3600, 18 * 3600]],
        [:fri] => [[8 * 3600, 16 * 3600]],
        [:sat] => [[10 * 3600, 14 * 3600]]
      }

      described_class.new(options).time_after(*args)
    end

    it 'returns the working time in after before given time' do
      expect(time_after(t('Mon Oct 31', '8:59'))).to eq(8 * 3600)
      expect(time_after(t('Mon Oct 31', '10:00'))).to eq(7 * 3600)
      expect(time_after(t('Mon Oct 31', '16:00'))).to eq(1 * 3600)
      expect(time_after(t('Mon Oct 31', '19:00'))).to eq(0)

      expect(time_after(t('Tue Nov 1', '8:59'))).to eq(10 * 3600)
      expect(time_after(t('Tue Nov 1', '10:00'))).to eq(9 * 3600)
      expect(time_after(t('Tue Nov 1', '16:00'))).to eq(4 * 3600)
      expect(time_after(t('Tue Nov 1', '19:00'))).to eq(1 * 3600)
      expect(time_after(t('Tue Nov 1', '20:00'))).to eq(0 * 3600)

      expect(time_after(t('Wed Nov 2', '8:59'))).to eq(9 * 3600)
      expect(time_after(t('Wed Nov 2', '10:00'))).to eq(8 * 3600)
      expect(time_after(t('Wed Nov 2', '16:00'))).to eq(2 * 3600)
      expect(time_after(t('Wed Nov 2', '19:00'))).to eq(0 * 3600)

      expect(time_after(t('Thu Nov 3', '8:59'))).to eq(10 * 3600)
      expect(time_after(t('Thu Nov 3', '10:00'))).to eq(9 * 3600)
      expect(time_after(t('Thu Nov 3', '16:00'))).to eq(4 * 3600)
      expect(time_after(t('Thu Nov 3', '19:00'))).to eq(1 * 3600)
      expect(time_after(t('Thu Nov 3', '20:00'))).to eq(0 * 3600)

      expect(time_after(t('Fri Nov 4', '7:59'))).to eq(8 * 3600)
      expect(time_after(t('Fri Nov 4', '10:00'))).to eq(6 * 3600)
      expect(time_after(t('Fri Nov 4', '16:00'))).to eq(0 * 3600)
      expect(time_after(t('Fri Nov 4', '19:00'))).to eq(0 * 3600)

      expect(time_after(t('Sat Nov 5', '10:00'))).to eq(4 * 3600)
      expect(time_after(t('Sat Nov 5', '16:00'))).to eq(0)
      expect(time_after(t('Sat Nov 5', '19:00'))).to eq(0)

      expect(time_after(t('Sun Nov 6', '12:00'))).to eq(0)
      expect(time_after(t('Sun Nov 6', '19:00'))).to eq(0)
    end
  end
end
