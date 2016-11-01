require 'spec_helper'

describe BetterBusinessTime::Time do
  describe '.between' do
    def described_method(*args)
      described_class.between(*args)
    end

    it 'returns business time between two times two days apart' do
      expect(described_method(t('Mon Oct 31', '17:01'), t('Wed Nov 2', '8:59'))).to eq(8 * 3600)
      expect(described_method(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '8:59'))).to eq(9 * 3600)
      expect(described_method(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '10:00'))).to eq(10 * 3600)
      expect(described_method(t('Mon Oct 31', '8:00'), t('Wed Nov 2', '10:00'))).to eq(17 * 3600)
    end

    it 'returns business time between two times one day apart' do
      expect(described_method(t('Tue Nov 1', '17:01'), t('Wed Nov 2', '8:59'))).to eq(0 * 3600)
      expect(described_method(t('Tue Nov 1', '16:00'), t('Wed Nov 2', '8:59'))).to eq(1 * 3600)
      expect(described_method(t('Tue Nov 1', '16:00'), t('Wed Nov 2', '10:00'))).to eq(2 * 3600)
      expect(described_method(t('Tue Nov 1', '8:00'), t('Wed Nov 2', '10:00'))).to eq(9 * 3600)
    end

    it 'returns business time between two times in the same say' do
      expect(described_method(t('Tue Nov 1', '8:59'), t('Tue Nov 1', '17:01'))).to eq(8 * 3600)
      expect(described_method(t('Tue Nov 1', '10:00'), t('Tue Nov 1', '16:00'))).to eq(6 * 3600)
      expect(described_method(t('Tue Nov 1', '8:00'), t('Tue Nov 1', '16:00'))).to eq(7 * 3600)
      expect(described_method(t('Tue Nov 1', '10:00'), t('Tue Nov 1', '18:00'))).to eq(7 * 3600)
    end

    it 'returns business time between two times when there are vacations between' do
      BetterBusinessTime::WeekdayHolidays.set([d('Tue Nov 1'), d('Tue Nov 15')])

      expect(described_method(t('Mon Oct 31', '17:01'), t('Wed Nov 2', '8:59'))).to eq(0 * 3600)
      expect(described_method(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '8:59'))).to eq(1 * 3600)
      expect(described_method(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '10:00'))).to eq(2 * 3600)
      expect(described_method(t('Mon Oct 31', '8:00'), t('Wed Nov 2', '10:00'))).to eq(9 * 3600)
    end

    it 'returns business time when there is a holiday in the first edge' do
      BetterBusinessTime::WeekdayHolidays.set([d('Mon Oct 31'), d('Tue Nov 15')])

      expect(described_method(t('Mon Oct 31', '17:01'), t('Wed Nov 2', '8:59'))).to eq(8 * 3600)
      expect(described_method(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '8:59'))).to eq(8 * 3600)
      expect(described_method(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '10:00'))).to eq(9 * 3600)
      expect(described_method(t('Mon Oct 31', '8:00'), t('Wed Nov 2', '10:00'))).to eq(9 * 3600)
    end

    it 'returns business time when there is a holiday in the last edge' do
      BetterBusinessTime::WeekdayHolidays.set([d('Wed Nov 2'), d('Tue Nov 15')])

      expect(described_method(t('Mon Oct 31', '17:01'), t('Wed Nov 2', '8:59'))).to eq(8 * 3600)
      expect(described_method(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '8:59'))).to eq(9 * 3600)
      expect(described_method(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '10:00'))).to eq(9 * 3600)
      expect(described_method(t('Mon Oct 31', '8:00'), t('Wed Nov 2', '10:00'))).to eq(16 * 3600)
    end

    it 'returns 0 when the times are on the same day but holidays' do
      BetterBusinessTime::WeekdayHolidays.set([d('Wed Nov 2'), d('Tue Nov 15')])

      expect(described_method(t('Wed Nov 2', '10:00'), t('Wed Nov 2', '18:00'))).to eq(0)
    end
  end

  describe '.overlap' do
    def described_method(*args)
      described_class.segment_intersection(*args)
    end

    it 'returns the time intersection between two segments' do
      expect(described_method([9, 17], [10, 16])).to eq(6)
      expect(described_method([9, 17], [10, 18])).to eq(7)
      expect(described_method([9, 17], [10, 20])).to eq(7)
      expect(described_method([9, 17], [8, 20])).to eq(8)
      expect(described_method([9, 17], [2, 6])).to eq(0)
      expect(described_method([2, 6], [9, 17])).to eq(0)
    end
  end
end
