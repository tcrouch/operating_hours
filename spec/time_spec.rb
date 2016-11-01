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

    context 'real holidays' do
      before do
        BetterBusinessTime::WeekdayHolidays.set(
          [
            d('Fri Jan 1'),
            d('Mon Jan 18'),
            d('Mon Feb 15'),
            d('Mon May 30'),
            d('Mon Jul 4'),
            d('Mon Sep 5'),
            d('Mon Oct 10'),
            d('Fri Nov 11'),
            d('Thu Nov 24'),
            d('Sun Dec 25'),
            Date.new(2017, 1, 1),
            Date.new(2017, 1, 30)
          ]
        )
      end

      it 'calculates business time' do
        one_work_day = 8 * 3600
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Jan 4', '18:01'))).to eq(one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Jan 18', '18:01'))).to eq(10 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Feb 8', '18:01'))).to eq(25 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Feb 15', '18:01'))).to eq(29 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Feb 29', '18:01'))).to eq(39 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Mar 28', '18:01'))).to eq(59 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Apr 4', '18:01'))).to eq(64 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Apr 25', '18:01'))).to eq(79 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon May 2', '18:01'))).to eq(84 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon May 30', '18:01'))).to eq(103 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Jun 6', '18:01'))).to eq(108 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Jun 27', '18:01'))).to eq(123 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Jul 4', '18:01'))).to eq(127 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Jul 25', '18:01'))).to eq(142 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Aug 1', '18:01'))).to eq(147 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Aug 29', '18:01'))).to eq(167 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Sep 5', '18:01'))).to eq(171 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Sep 26', '18:01'))).to eq(186 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Oct 3', '18:01'))).to eq(191 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Oct 10', '18:01'))).to eq(195 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Oct 31', '18:01'))).to eq(210 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Nov 28', '18:01'))).to eq(228 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Dec 5', '18:01'))).to eq(233 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Mon Dec 26', '18:01'))).to eq(248 * one_work_day)
        expect(described_method(t('Fri Jan 1', '9:00'), t('Fri Dec 30', '18:01'))).to eq(252 * one_work_day)
      end
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
