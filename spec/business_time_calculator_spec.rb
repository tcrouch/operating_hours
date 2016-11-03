require 'spec_helper'

describe BusinessTimeCalculator do
  let(:schedule) do
    { [:mon, :tue, :wed, :thu, :fri] => [[9 * 60 * 60, 17 * 60 * 60]] }
  end
  let(:holidays) { [] }

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
end
