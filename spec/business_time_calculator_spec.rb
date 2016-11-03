require 'spec_helper'

describe BusinessTimeCalculator do
  let(:schedule) do
    { [:mon, :tue, :wed, :thu, :fri] => [[9 * 60 * 60, 17 * 60 * 60]] }
  end
  let(:holidays) { nil }

  let(:subject) do
    described_class.new(schedule: schedule, holidays: holidays)
  end

  describe '.time_between' do
    def time_between(*args)
      subject.time_between(*args)
    end

    it 'returns business time between two times two days apart' do
      expect(time_between(t('Mon Oct 31', '17:01'), t('Wed Nov 2', '8:59'))).to eq(8 * 3600)
      expect(time_between(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '8:59'))).to eq(9 * 3600)
      expect(time_between(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '10:00'))).to eq(10 * 3600)
      expect(time_between(t('Mon Oct 31', '8:00'), t('Wed Nov 2', '10:00'))).to eq(17 * 3600)
    end

    it 'returns business time between two times one day apart' do
      expect(time_between(t('Tue Nov 1', '17:01'), t('Wed Nov 2', '8:59'))).to eq(0 * 3600)
      expect(time_between(t('Tue Nov 1', '16:00'), t('Wed Nov 2', '8:59'))).to eq(1 * 3600)
      expect(time_between(t('Tue Nov 1', '16:00'), t('Wed Nov 2', '10:00'))).to eq(2 * 3600)
      expect(time_between(t('Tue Nov 1', '8:00'), t('Wed Nov 2', '10:00'))).to eq(9 * 3600)
    end

    it 'returns business time between two times in the same say' do
      expect(time_between(t('Tue Nov 1', '8:59'), t('Tue Nov 1', '17:01'))).to eq(8 * 3600)
      expect(time_between(t('Tue Nov 1', '10:00'), t('Tue Nov 1', '16:00'))).to eq(6 * 3600)
      expect(time_between(t('Tue Nov 1', '8:00'), t('Tue Nov 1', '16:00'))).to eq(7 * 3600)
      expect(time_between(t('Tue Nov 1', '10:00'), t('Tue Nov 1', '18:00'))).to eq(7 * 3600)
    end

    context 'with holidays' do
      let(:holidays) do
        [d('Tue Nov 1'), d('Fri Nov 4'), d('Tue Nov 8')]
      end

      def between(*args)
        subject.time_between(*args)
      end

      it 'returns business time between two times when there are vacations between' do
        expect(time_between(t('Mon Oct 31', '17:01'), t('Wed Nov 2', '8:59'))).to eq(0 * 3600)
        expect(time_between(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '8:59'))).to eq(1 * 3600)
        expect(time_between(t('Mon Oct 31', '16:00'), t('Wed Nov 2', '10:00'))).to eq(2 * 3600)
        expect(time_between(t('Mon Oct 31', '8:00'), t('Wed Nov 2', '10:00'))).to eq(9 * 3600)
      end

      it 'returns business time when there is a holiday in the first edge' do
        expect(time_between(t('Tue Nov 1', '17:01'), t('Thu Nov 3', '8:59'))).to eq(8 * 3600)
        expect(time_between(t('Tue Nov 1', '16:00'), t('Thu Nov 3', '8:59'))).to eq(8 * 3600)
        expect(time_between(t('Tue Nov 1', '16:00'), t('Thu Nov 3', '10:00'))).to eq(9 * 3600)
        expect(time_between(t('Tue Nov 1', '8:00'), t('Thu Nov 3', '10:00'))).to eq(9 * 3600)
      end

      it 'returns business time when there is a holiday in the last edge' do
        expect(time_between(t('Wed Nov 2', '17:01'), t('Fri Nov 4', '8:59'))).to eq(8 * 3600)
        expect(time_between(t('Wed Nov 2', '16:00'), t('Fri Nov 4', '8:59'))).to eq(9 * 3600)
        expect(time_between(t('Wed Nov 2', '16:00'), t('Fri Nov 4', '10:00'))).to eq(9 * 3600)
        expect(time_between(t('Wed Nov 2', '8:00'), t('Fri Nov 4', '10:00'))).to eq(16 * 3600)
      end

      it 'returns 0 when the times are in the same day and on a holiday' do
        expect(time_between(t('Tue Nov 1', '10:00'), t('Tue Nov 1', '18:00'))).to eq(0)
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

      def time_between(*args)
        subject.time_between(*args)
      end

      it 'calculates business time' do
        one_work_day = 8 * 3600
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Jan 4', '18:01'))).to eq(one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Jan 18', '18:01'))).to eq(10 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Feb 8', '18:01'))).to eq(25 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Feb 15', '18:01'))).to eq(29 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Feb 29', '18:01'))).to eq(39 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Mar 28', '18:01'))).to eq(59 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Apr 4', '18:01'))).to eq(64 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Apr 25', '18:01'))).to eq(79 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon May 2', '18:01'))).to eq(84 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon May 30', '18:01'))).to eq(103 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Jun 6', '18:01'))).to eq(108 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Jun 27', '18:01'))).to eq(123 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Jul 4', '18:01'))).to eq(127 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Jul 25', '18:01'))).to eq(142 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Aug 1', '18:01'))).to eq(147 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Aug 29', '18:01'))).to eq(167 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Sep 5', '18:01'))).to eq(171 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Sep 26', '18:01'))).to eq(186 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Oct 3', '18:01'))).to eq(191 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Oct 10', '18:01'))).to eq(195 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Oct 31', '18:01'))).to eq(210 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Nov 28', '18:01'))).to eq(228 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Dec 5', '18:01'))).to eq(233 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Mon Dec 26', '18:01'))).to eq(248 * one_work_day)
        expect(time_between(t('Fri Jan 1', '9:00'), t('Fri Dec 30', '18:01'))).to eq(252 * one_work_day)
      end
    end
  end

  describe '.days_in_range' do
    def days_in_range(*args)
      subject.days_in_range(*args)
    end

    it 'returns business days between two dates starting Monday' do
      expect(days_in_range(d('Mon Oct 31'), d('Mon Oct 31'))).to eq(1)
      expect(days_in_range(d('Mon Oct 31'), d('Tue Nov 1'))).to eq(2)
      expect(days_in_range(d('Mon Oct 31'), d('Wed Nov 2'))).to eq(3)
      expect(days_in_range(d('Mon Oct 31'), d('Thu Nov 3'))).to eq(4)
      expect(days_in_range(d('Mon Oct 31'), d('Fri Nov 4'))).to eq(5)
      expect(days_in_range(d('Mon Oct 31'), d('Sat Nov 5'))).to eq(5)
      expect(days_in_range(d('Mon Oct 31'), d('Sun Nov 6'))).to eq(5)
      expect(days_in_range(d('Mon Oct 31'), d('Mon Nov 7'))).to eq(6)
    end

    it 'returns business days between two dates starting Tuesday' do
      expect(days_in_range(d('Tue Nov 1'), d('Tue Nov 1'))).to eq(1)
      expect(days_in_range(d('Tue Nov 1'), d('Wed Nov 2'))).to eq(2)
      expect(days_in_range(d('Tue Nov 1'), d('Thu Nov 3'))).to eq(3)
      expect(days_in_range(d('Tue Nov 1'), d('Fri Nov 4'))).to eq(4)
      expect(days_in_range(d('Tue Nov 1'), d('Sat Nov 5'))).to eq(4)
      expect(days_in_range(d('Tue Nov 1'), d('Sun Nov 6'))).to eq(4)
      expect(days_in_range(d('Tue Nov 1'), d('Mon Nov 7'))).to eq(5)
      expect(days_in_range(d('Tue Nov 1'), d('Tue Nov 8'))).to eq(6)
    end

    it 'returns business days between two dates starting Wednesday' do
      expect(days_in_range(d('Wed Nov 2'), d('Wed Nov 2'))).to eq(1)
      expect(days_in_range(d('Wed Nov 2'), d('Thu Nov 3'))).to eq(2)
      expect(days_in_range(d('Wed Nov 2'), d('Fri Nov 4'))).to eq(3)
      expect(days_in_range(d('Wed Nov 2'), d('Sat Nov 5'))).to eq(3)
      expect(days_in_range(d('Wed Nov 2'), d('Sun Nov 6'))).to eq(3)
      expect(days_in_range(d('Wed Nov 2'), d('Mon Nov 7'))).to eq(4)
      expect(days_in_range(d('Wed Nov 2'), d('Tue Nov 8'))).to eq(5)
      expect(days_in_range(d('Wed Nov 2'), d('Wed Nov 9'))).to eq(6)
    end

    it 'returns business days between two dates starting Thursday' do
      expect(days_in_range(d('Thu Nov 3'), d('Thu Nov 3'))).to eq(1)
      expect(days_in_range(d('Thu Nov 3'), d('Fri Nov 4'))).to eq(2)
      expect(days_in_range(d('Thu Nov 3'), d('Sat Nov 5'))).to eq(2)
      expect(days_in_range(d('Thu Nov 3'), d('Sun Nov 6'))).to eq(2)
      expect(days_in_range(d('Thu Nov 3'), d('Mon Nov 7'))).to eq(3)
      expect(days_in_range(d('Thu Nov 3'), d('Tue Nov 8'))).to eq(4)
      expect(days_in_range(d('Thu Nov 3'), d('Wed Nov 9'))).to eq(5)
      expect(days_in_range(d('Thu Nov 3'), d('Thu Nov 10'))).to eq(6)
    end

    it 'returns business days between two dates starting Friday' do
      expect(days_in_range(d('Fri Nov 4'), d('Fri Nov 4'))).to eq(1)
      expect(days_in_range(d('Fri Nov 4'), d('Sat Nov 5'))).to eq(1)
      expect(days_in_range(d('Fri Nov 4'), d('Sun Nov 6'))).to eq(1)
      expect(days_in_range(d('Fri Nov 4'), d('Mon Nov 7'))).to eq(2)
      expect(days_in_range(d('Fri Nov 4'), d('Tue Nov 8'))).to eq(3)
      expect(days_in_range(d('Fri Nov 4'), d('Wed Nov 9'))).to eq(4)
      expect(days_in_range(d('Fri Nov 4'), d('Thu Nov 10'))).to eq(5)
      expect(days_in_range(d('Fri Nov 4'), d('Fri Nov 11'))).to eq(6)
    end

    it 'returns business days between two dates starting Saturday' do
      expect(days_in_range(d('Sat Nov 5'), d('Sat Nov 5'))).to eq(0)
      expect(days_in_range(d('Sat Nov 5'), d('Sun Nov 6'))).to eq(0)
      expect(days_in_range(d('Sat Nov 5'), d('Mon Nov 7'))).to eq(1)
      expect(days_in_range(d('Sat Nov 5'), d('Tue Nov 8'))).to eq(2)
      expect(days_in_range(d('Sat Nov 5'), d('Wed Nov 9'))).to eq(3)
      expect(days_in_range(d('Sat Nov 5'), d('Thu Nov 10'))).to eq(4)
      expect(days_in_range(d('Sat Nov 5'), d('Fri Nov 11'))).to eq(5)
      expect(days_in_range(d('Sat Nov 5'), d('Sat Nov 12'))).to eq(5)
    end

    it 'returns business days between two dates starting Sunday' do
      expect(days_in_range(d('Sun Nov 6'), d('Sun Nov 6'))).to eq(0)
      expect(days_in_range(d('Sun Nov 6'), d('Mon Nov 7'))).to eq(1)
      expect(days_in_range(d('Sun Nov 6'), d('Tue Nov 8'))).to eq(2)
      expect(days_in_range(d('Sun Nov 6'), d('Wed Nov 9'))).to eq(3)
      expect(days_in_range(d('Sun Nov 6'), d('Thu Nov 10'))).to eq(4)
      expect(days_in_range(d('Sun Nov 6'), d('Fri Nov 11'))).to eq(5)
      expect(days_in_range(d('Sun Nov 6'), d('Sat Nov 12'))).to eq(5)
      expect(days_in_range(d('Sun Nov 6'), d('Sun Nov 13'))).to eq(5)
    end

    context 'with holidays' do
      let(:holidays) do
        [d('Sun Oct 30'), d('Tue Nov 1'), d('Wed Nov 9')]
      end

      def days_in_range(*args)
        subject.days_in_range(*args)
      end

      it 'excludes holidays' do
        expect(days_in_range(d('Mon Oct 31'), d('Mon Oct 31'))).to eq(1)
        expect(days_in_range(d('Mon Oct 31'), d('Tue Nov 1'))).to eq(1)
        expect(days_in_range(d('Mon Oct 31'), d('Wed Nov 2'))).to eq(2)
        expect(days_in_range(d('Mon Oct 31'), d('Thu Nov 3'))).to eq(3)
        expect(days_in_range(d('Mon Oct 31'), d('Fri Nov 4'))).to eq(4)
        expect(days_in_range(d('Mon Oct 31'), d('Sat Nov 5'))).to eq(4)
        expect(days_in_range(d('Mon Oct 31'), d('Sun Nov 6'))).to eq(4)
        expect(days_in_range(d('Mon Oct 31'), d('Mon Nov 7'))).to eq(5)
      end
    end
  end

  describe '.weekend_days_in_range' do
    def weekend_days_in_range(*args)
      subject.weekend_days_in_range(*args)
    end

    describe 'when distance <= 1 week' do
      it 'returns weekend days between Monday and another date' do
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Mon Nov 7'))).to eq(0)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Tue Nov 8'))).to eq(0)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Wed Nov 9'))).to eq(0)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Thu Nov 10'))).to eq(0)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Fri Nov 11'))).to eq(0)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Sat Nov 12'))).to eq(1)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Sun Nov 13'))).to eq(2)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Mon Nov 14'))).to eq(2)
      end

      it 'returns weekend days between Tuesday and another date' do
        expect(weekend_days_in_range(d('Tue Nov 8'), d('Tue Nov 8'))).to eq(0)
        expect(weekend_days_in_range(d('Tue Nov 8'), d('Wed Nov 9'))).to eq(0)
        expect(weekend_days_in_range(d('Tue Nov 8'), d('Thu Nov 10'))).to eq(0)
        expect(weekend_days_in_range(d('Tue Nov 8'), d('Fri Nov 11'))).to eq(0)
        expect(weekend_days_in_range(d('Tue Nov 8'), d('Sat Nov 12'))).to eq(1)
        expect(weekend_days_in_range(d('Tue Nov 8'), d('Sun Nov 13'))).to eq(2)
        expect(weekend_days_in_range(d('Tue Nov 8'), d('Mon Nov 14'))).to eq(2)
        expect(weekend_days_in_range(d('Tue Nov 8'), d('Tue Nov 15'))).to eq(2)
      end

      it 'returns weekend days between Wednesday and another date' do
        expect(weekend_days_in_range(d('Wed Nov 9'), d('Wed Nov 9'))).to eq(0)
        expect(weekend_days_in_range(d('Wed Nov 9'), d('Thu Nov 10'))).to eq(0)
        expect(weekend_days_in_range(d('Wed Nov 9'), d('Fri Nov 11'))).to eq(0)
        expect(weekend_days_in_range(d('Wed Nov 9'), d('Sat Nov 12'))).to eq(1)
        expect(weekend_days_in_range(d('Wed Nov 9'), d('Sun Nov 13'))).to eq(2)
        expect(weekend_days_in_range(d('Wed Nov 9'), d('Mon Nov 14'))).to eq(2)
        expect(weekend_days_in_range(d('Wed Nov 9'), d('Tue Nov 15'))).to eq(2)
        expect(weekend_days_in_range(d('Wed Nov 9'), d('Wed Nov 16'))).to eq(2)
      end

      it 'returns weekend days between Thursday and another date' do
        expect(weekend_days_in_range(d('Thu Nov 10'), d('Thu Nov 10'))).to eq(0)
        expect(weekend_days_in_range(d('Thu Nov 10'), d('Fri Nov 11'))).to eq(0)
        expect(weekend_days_in_range(d('Thu Nov 10'), d('Sat Nov 12'))).to eq(1)
        expect(weekend_days_in_range(d('Thu Nov 10'), d('Sun Nov 13'))).to eq(2)
        expect(weekend_days_in_range(d('Thu Nov 10'), d('Mon Nov 14'))).to eq(2)
        expect(weekend_days_in_range(d('Thu Nov 10'), d('Tue Nov 15'))).to eq(2)
        expect(weekend_days_in_range(d('Thu Nov 10'), d('Wed Nov 16'))).to eq(2)
        expect(weekend_days_in_range(d('Thu Nov 10'), d('Thu Nov 17'))).to eq(2)
      end

      it 'returns weekend days between Friday and another date' do
        expect(weekend_days_in_range(d('Fri Nov 11'), d('Fri Nov 11'))).to eq(0)
        expect(weekend_days_in_range(d('Fri Nov 11'), d('Sat Nov 12'))).to eq(1)
        expect(weekend_days_in_range(d('Fri Nov 11'), d('Sun Nov 13'))).to eq(2)
        expect(weekend_days_in_range(d('Fri Nov 11'), d('Mon Nov 14'))).to eq(2)
        expect(weekend_days_in_range(d('Fri Nov 11'), d('Tue Nov 15'))).to eq(2)
        expect(weekend_days_in_range(d('Fri Nov 11'), d('Wed Nov 16'))).to eq(2)
        expect(weekend_days_in_range(d('Fri Nov 11'), d('Thu Nov 17'))).to eq(2)
        expect(weekend_days_in_range(d('Fri Nov 11'), d('Fri Nov 18'))).to eq(2)
      end

      it 'returns weekend days between Saturday and another day' do
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Sat Nov 5'))).to eq(1)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Sun Nov 6'))).to eq(2)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Mon Nov 7'))).to eq(2)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Tue Nov 8'))).to eq(2)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Wed Nov 9'))).to eq(2)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Thu Nov 10'))).to eq(2)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Fri Nov 11'))).to eq(2)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Sat Nov 12'))).to eq(3)
      end

      it 'returns weekend days between two dates starting Sunday' do
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Sun Nov 6'))).to eq(1)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Mon Nov 7'))).to eq(1)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Tue Nov 8'))).to eq(1)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Wed Nov 9'))).to eq(1)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Thu Nov 10'))).to eq(1)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Fri Nov 11'))).to eq(1)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Sat Nov 12'))).to eq(2)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Sun Nov 13'))).to eq(3)
      end
    end

    describe 'when distance > 1 week' do
      it 'returns weekend days between Monday and another date' do
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Mon Nov 21'))).to eq(4)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Tue Nov 22'))).to eq(4)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Wed Nov 23'))).to eq(4)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Thu Nov 24'))).to eq(4)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Fri Nov 25'))).to eq(4)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Sat Nov 26'))).to eq(5)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Sun Nov 27'))).to eq(6)
        expect(weekend_days_in_range(d('Mon Nov 7'), d('Mon Nov 28'))).to eq(6)
      end

      it 'returns weekend days between Tuesday and another date' do
        expect(weekend_days_in_range(d('Tue Nov 1'), d('Tue Nov 15'))).to eq(4)
        expect(weekend_days_in_range(d('Tue Nov 1'), d('Wed Nov 16'))).to eq(4)
        expect(weekend_days_in_range(d('Tue Nov 1'), d('Thu Nov 17'))).to eq(4)
        expect(weekend_days_in_range(d('Tue Nov 1'), d('Fri Nov 18'))).to eq(4)
        expect(weekend_days_in_range(d('Tue Nov 1'), d('Sat Nov 19'))).to eq(5)
        expect(weekend_days_in_range(d('Tue Nov 1'), d('Sun Nov 20'))).to eq(6)
        expect(weekend_days_in_range(d('Tue Nov 1'), d('Mon Nov 21'))).to eq(6)
        expect(weekend_days_in_range(d('Tue Nov 1'), d('Tue Nov 22'))).to eq(6)
      end

      it 'returns weekend days between Wednesday and another date' do
        expect(weekend_days_in_range(d('Wed Nov 2'), d('Wed Nov 16'))).to eq(4)
        expect(weekend_days_in_range(d('Wed Nov 2'), d('Thu Nov 17'))).to eq(4)
        expect(weekend_days_in_range(d('Wed Nov 2'), d('Fri Nov 18'))).to eq(4)
        expect(weekend_days_in_range(d('Wed Nov 2'), d('Sat Nov 19'))).to eq(5)
        expect(weekend_days_in_range(d('Wed Nov 2'), d('Sun Nov 20'))).to eq(6)
        expect(weekend_days_in_range(d('Wed Nov 2'), d('Mon Nov 21'))).to eq(6)
        expect(weekend_days_in_range(d('Wed Nov 2'), d('Tue Nov 22'))).to eq(6)
        expect(weekend_days_in_range(d('Wed Nov 2'), d('Wed Nov 23'))).to eq(6)
      end

      it 'returns weekend days between Thursday and another date' do
        expect(weekend_days_in_range(d('Thu Nov 3'), d('Thu Nov 17'))).to eq(4)
        expect(weekend_days_in_range(d('Thu Nov 3'), d('Fri Nov 18'))).to eq(4)
        expect(weekend_days_in_range(d('Thu Nov 3'), d('Sat Nov 19'))).to eq(5)
        expect(weekend_days_in_range(d('Thu Nov 3'), d('Sun Nov 20'))).to eq(6)
        expect(weekend_days_in_range(d('Thu Nov 3'), d('Mon Nov 21'))).to eq(6)
        expect(weekend_days_in_range(d('Thu Nov 3'), d('Tue Nov 22'))).to eq(6)
        expect(weekend_days_in_range(d('Thu Nov 3'), d('Wed Nov 23'))).to eq(6)
        expect(weekend_days_in_range(d('Thu Nov 3'), d('Thu Nov 24'))).to eq(6)
      end

      it 'returns weekend days between Friday and another date' do
        expect(weekend_days_in_range(d('Fri Nov 4'), d('Fri Nov 18'))).to eq(4)
        expect(weekend_days_in_range(d('Fri Nov 4'), d('Sat Nov 19'))).to eq(5)
        expect(weekend_days_in_range(d('Fri Nov 4'), d('Sun Nov 20'))).to eq(6)
        expect(weekend_days_in_range(d('Fri Nov 4'), d('Mon Nov 21'))).to eq(6)
        expect(weekend_days_in_range(d('Fri Nov 4'), d('Tue Nov 22'))).to eq(6)
        expect(weekend_days_in_range(d('Fri Nov 4'), d('Wed Nov 23'))).to eq(6)
        expect(weekend_days_in_range(d('Fri Nov 4'), d('Thu Nov 24'))).to eq(6)
        expect(weekend_days_in_range(d('Fri Nov 4'), d('Fri Nov 25'))).to eq(6)
      end

      it 'returns weekend days between Sunday and another date' do
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Sat Nov 19'))).to eq(5)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Sun Nov 20'))).to eq(6)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Mon Nov 21'))).to eq(6)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Tue Nov 22'))).to eq(6)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Wed Nov 23'))).to eq(6)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Thu Nov 24'))).to eq(6)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Fri Nov 25'))).to eq(6)
        expect(weekend_days_in_range(d('Sat Nov 5'), d('Sat Nov 26'))).to eq(7)
      end

      it 'returns weekend days between Sunday and another date' do
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Sun Nov 20'))).to eq(5)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Mon Nov 21'))).to eq(5)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Tue Nov 22'))).to eq(5)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Wed Nov 23'))).to eq(5)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Thu Nov 24'))).to eq(5)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Fri Nov 25'))).to eq(5)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Sat Nov 26'))).to eq(6)
        expect(weekend_days_in_range(d('Sun Nov 6'), d('Sun Nov 27'))).to eq(7)
      end
    end
  end
end
