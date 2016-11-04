require 'spec_helper'

describe BusinessTimeCalculator::Calculator do
  let(:schedule) do
    { [:mon, :tue, :wed, :thu, :fri] => [[9 * 60 * 60, 17 * 60 * 60]] }
  end
  let(:holidays) { [] }

  let(:subject) do
    described_class.new(schedule: schedule, holidays: holidays)
  end

  describe '.seconds_between' do
    def seconds_between(*args)
      subject.seconds_between(*args)
    end

    it 'returns business time between two times two days apart' do
      expect(seconds_between(t('Mon Oct 31', '17:01'), t('Wed Nov 2', '8:59'))).to eq(8 * 3600)
      expect(seconds_between(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '8:59'))).to eq(9 * 3600)
      expect(seconds_between(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '10:00'))).to eq(10 * 3600)
      expect(seconds_between(t('Mon Oct 31', '8:00'), t('Wed Nov 2', '10:00'))).to eq(17 * 3600)
    end

    it 'returns business time between two times one day apart' do
      expect(seconds_between(t('Tue Nov 1', '17:01'), t('Wed Nov 2', '8:59'))).to eq(0 * 3600)
      expect(seconds_between(t('Tue Nov 1', '16:00'), t('Wed Nov 2', '8:59'))).to eq(1 * 3600)
      expect(seconds_between(t('Tue Nov 1', '16:00'), t('Wed Nov 2', '10:00'))).to eq(2 * 3600)
      expect(seconds_between(t('Tue Nov 1', '8:00'), t('Wed Nov 2', '10:00'))).to eq(9 * 3600)
    end

    it 'returns business time between two times in the same say' do
      expect(seconds_between(t('Tue Nov 1', '8:59'), t('Tue Nov 1', '17:01'))).to eq(8 * 3600)
      expect(seconds_between(t('Tue Nov 1', '10:00'), t('Tue Nov 1', '16:00'))).to eq(6 * 3600)
      expect(seconds_between(t('Tue Nov 1', '8:00'), t('Tue Nov 1', '16:00'))).to eq(7 * 3600)
      expect(seconds_between(t('Tue Nov 1', '10:00'), t('Tue Nov 1', '18:00'))).to eq(7 * 3600)
    end

    context 'with holidays' do
      let(:holidays) do
        [d('Tue Nov 1'), d('Fri Nov 4'), d('Tue Nov 8')]
      end

      def between(*args)
        subject.seconds_between(*args)
      end

      it 'returns business time between two times when there are vacations between' do
        expect(seconds_between(t('Mon Oct 31', '17:01'), t('Wed Nov 2', '8:59'))).to eq(0 * 3600)
        expect(seconds_between(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '8:59'))).to eq(1 * 3600)
        expect(seconds_between(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '10:00'))).to eq(2 * 3600)
        expect(seconds_between(t('Mon Oct 31', '8:00'), t('Wed Nov 2', '10:00'))).to eq(9 * 3600)
      end

      it 'returns business time when there is a holiday in the first edge' do
        expect(seconds_between(t('Tue Nov 1', '17:01'), t('Thu Nov 3', '8:59'))).to eq(8 * 3600)
        expect(seconds_between(t('Tue Nov 1', '16:00'), t('Thu Nov 3', '8:59'))).to eq(8 * 3600)
        expect(seconds_between(t('Tue Nov 1', '16:00'), t('Thu Nov 3', '10:00'))).to eq(9 * 3600)
        expect(seconds_between(t('Tue Nov 1', '8:00'), t('Thu Nov 3', '10:00'))).to eq(9 * 3600)
      end

      it 'returns business time when there is a holiday in the last edge' do
        expect(seconds_between(t('Wed Nov 2', '17:01'), t('Fri Nov 4', '8:59'))).to eq(8 * 3600)
        expect(seconds_between(t('Wed Nov 2', '16:00'), t('Fri Nov 4', '8:59'))).to eq(9 * 3600)
        expect(seconds_between(t('Wed Nov 2', '16:00'), t('Fri Nov 4', '10:00'))).to eq(9 * 3600)
        expect(seconds_between(t('Wed Nov 2', '8:00'), t('Fri Nov 4', '10:00'))).to eq(16 * 3600)
      end

      it 'returns 0 when the times are in the same day and on a holiday' do
        expect(seconds_between(t('Tue Nov 1', '10:00'), t('Tue Nov 1', '18:00'))).to eq(0)
      end
    end

    context 'real holidays' do
      let(:holidays) do
        holidays = [
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
      end

      def seconds_between(*args)
        subject.seconds_between(*args)
      end

      it 'calculates business time' do
        one_work_day = 8 * 3600
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Jan 4', '18:01'))).to eq(one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Jan 18', '18:01'))).to eq(10 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Feb 8', '18:01'))).to eq(25 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Feb 15', '18:01'))).to eq(29 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Feb 29', '18:01'))).to eq(39 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Mar 28', '18:01'))).to eq(59 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Apr 4', '18:01'))).to eq(64 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Apr 25', '18:01'))).to eq(79 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon May 2', '18:01'))).to eq(84 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon May 30', '18:01'))).to eq(103 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Jun 6', '18:01'))).to eq(108 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Jun 27', '18:01'))).to eq(123 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Jul 4', '18:01'))).to eq(127 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Jul 25', '18:01'))).to eq(142 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Aug 1', '18:01'))).to eq(147 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Aug 29', '18:01'))).to eq(167 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Sep 5', '18:01'))).to eq(171 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Sep 26', '18:01'))).to eq(186 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Oct 3', '18:01'))).to eq(191 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Oct 10', '18:01'))).to eq(195 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Oct 31', '18:01'))).to eq(210 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Nov 28', '18:01'))).to eq(228 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Dec 5', '18:01'))).to eq(233 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Mon Dec 26', '18:01'))).to eq(248 * one_work_day)
        expect(seconds_between(t('Fri Jan 1', '9:00'), t('Fri Dec 30', '18:01'))).to eq(252 * one_work_day)
      end
    end
  end

  describe '.days_between_dates' do
    let(:holidays) do
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
    end

    def days_between_dates(*args)
      subject.days_between_dates(*args)
    end

    it 'calculates days between two dates' do
      expect(days_between_dates(d('Fri Jan 1'), d('Fri Jan 1'))).to eq(0)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Jan 4'))).to eq(0)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Jan 18'))).to eq(10)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Feb 8'))).to eq(24)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Feb 15'))).to eq(29)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Feb 29'))).to eq(38)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Mar 28'))).to eq(58)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Apr 4'))).to eq(63)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Apr 25'))).to eq(78)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon May 2'))).to eq(83)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon May 30'))).to eq(103)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Jun 6'))).to eq(107)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Jun 27'))).to eq(122)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Jul 4'))).to eq(127)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Jul 25'))).to eq(141)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Aug 1'))).to eq(146)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Aug 29'))).to eq(166)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Sep 5'))).to eq(171)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Sep 26'))).to eq(185)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Oct 3'))).to eq(190)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Oct 10'))).to eq(195)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Oct 31'))).to eq(209)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Nov 28'))).to eq(227)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Dec 5'))).to eq(232)
      expect(days_between_dates(d('Fri Jan 1'), d('Mon Dec 26'))).to eq(247)
      expect(days_between_dates(d('Fri Jan 1'), d('Fri Dec 30'))).to eq(251)
    end
  end
end
