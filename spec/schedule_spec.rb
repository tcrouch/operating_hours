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

  describe '#seconds_per_wday' do
    it 'returns the seconds in a given day' do
      options = {
        [:mon] => [[9 * 3600, 17 * 3600]],
        [:tue, :wed] => [[9 * 3600, 13 * 3600], [14 * 3600, 17 * 3600]],
        [:thu] => [[9 * 3600, 18 * 3600]],
        [:fri] => [[9 * 3600, 15 * 3600]],
      }
      schedule = described_class.new(options)

      expect(schedule.seconds_per_wday(0)).to eq(0)
      expect(schedule.seconds_per_wday(1)).to eq(8 * 3600)
      expect(schedule.seconds_per_wday(2)).to eq(7 * 3600)
      expect(schedule.seconds_per_wday(3)).to eq(7 * 3600)
      expect(schedule.seconds_per_wday(4)).to eq(9 * 3600)
      expect(schedule.seconds_per_wday(5)).to eq(6 * 3600)
      expect(schedule.seconds_per_wday(6)).to eq(0 * 3600)
    end
  end

  describe '#seconds_in_date_range' do
    def seconds_in_date_range(*args)
      options = {
        [:mon] => [[9 * 3600, 17 * 3600]],
        [:tue, :thu] => [[9 * 3600, 13 * 3600], [14 * 3600, 20 * 3600]],
        [:wed] => [[9 * 3600, 18 * 3600]],
        [:fri] => [[8 * 3600, 16 * 3600]],
        [:sat] => [[10 * 3600, 15 * 3600]]
      }

      described_class.new(options).seconds_in_date_range(*args)
    end

    describe 'dates less than a week apart' do
      it 'returns seconds in ranges starting on a Monday' do
        expect(seconds_in_date_range(d('Mon Oct 31'), d('Mon Oct 31'))).to eq(8 * 3600)
        expect(seconds_in_date_range(d('Mon Oct 31'), d('Tue Nov 1'))).to eq(18 * 3600)
        expect(seconds_in_date_range(d('Mon Oct 31'), d('Wed Nov 2'))).to eq(27 * 3600)
        expect(seconds_in_date_range(d('Mon Oct 31'), d('Thu Nov 3'))).to eq(37 * 3600)
        expect(seconds_in_date_range(d('Mon Oct 31'), d('Fri Nov 4'))).to eq(45 * 3600)
        expect(seconds_in_date_range(d('Mon Oct 31'), d('Sat Nov 5'))).to eq(50 * 3600)
      end

      it 'returns seconds in ranges starting on a Tuesday' do
        expect(seconds_in_date_range(d('Tue Oct 25'), d('Tue Oct 25'))).to eq(10 * 3600)
        expect(seconds_in_date_range(d('Tue Oct 25'), d('Wed Oct 26'))).to eq(19 * 3600)
        expect(seconds_in_date_range(d('Tue Oct 25'), d('Thu Oct 27'))).to eq(29 * 3600)
        expect(seconds_in_date_range(d('Tue Oct 25'), d('Fri Oct 28'))).to eq(37 * 3600)
        expect(seconds_in_date_range(d('Tue Oct 25'), d('Sat Oct 29'))).to eq(42 * 3600)
        expect(seconds_in_date_range(d('Tue Oct 25'), d('Sun Oct 30'))).to eq(42 * 3600)
      end

      it 'returns seconds in ranges starting on a Wednesday' do
        expect(seconds_in_date_range(d('Wed Oct 26'), d('Wed Oct 26'))).to eq(9 * 3600)
        expect(seconds_in_date_range(d('Wed Oct 26'), d('Thu Oct 27'))).to eq(19 * 3600)
        expect(seconds_in_date_range(d('Wed Oct 26'), d('Fri Oct 28'))).to eq(27 * 3600)
        expect(seconds_in_date_range(d('Wed Oct 26'), d('Sat Oct 29'))).to eq(32 * 3600)
        expect(seconds_in_date_range(d('Wed Oct 26'), d('Sun Oct 30'))).to eq(32 * 3600)
        expect(seconds_in_date_range(d('Wed Oct 26'), d('Mon Oct 31'))).to eq(40 * 3600)
      end

      it 'returns seconds in ranges starting on a Thursday' do
        expect(seconds_in_date_range(d('Thu Oct 27'), d('Thu Oct 27'))).to eq(10 * 3600)
        expect(seconds_in_date_range(d('Thu Oct 27'), d('Fri Oct 28'))).to eq(18 * 3600)
        expect(seconds_in_date_range(d('Thu Oct 27'), d('Sat Oct 29'))).to eq(23 * 3600)
        expect(seconds_in_date_range(d('Thu Oct 27'), d('Sun Oct 30'))).to eq(23 * 3600)
        expect(seconds_in_date_range(d('Thu Oct 27'), d('Mon Oct 31'))).to eq(31 * 3600)
        expect(seconds_in_date_range(d('Thu Oct 27'), d('Tue Nov 1'))).to eq(41 * 3600)
      end

      it 'returns seconds in ranges starting on a Friday' do
        expect(seconds_in_date_range(d('Fri Oct 28'), d('Fri Oct 28'))).to eq(8 * 3600)
        expect(seconds_in_date_range(d('Fri Oct 28'), d('Sat Oct 29'))).to eq(13 * 3600)
        expect(seconds_in_date_range(d('Fri Oct 28'), d('Sun Oct 30'))).to eq(13 * 3600)
        expect(seconds_in_date_range(d('Fri Oct 28'), d('Mon Oct 31'))).to eq(21 * 3600)
        expect(seconds_in_date_range(d('Fri Oct 28'), d('Tue Nov 1'))).to eq(31 * 3600)
        expect(seconds_in_date_range(d('Fri Oct 28'), d('Wed Nov 2'))).to eq(40 * 3600)
      end

      it 'returns seconds in ranges starting on a Saturday' do
        expect(seconds_in_date_range(d('Sat Oct 29'), d('Sat Oct 29'))).to eq(5 * 3600)
        expect(seconds_in_date_range(d('Sat Oct 29'), d('Sun Oct 30'))).to eq(5 * 3600)
        expect(seconds_in_date_range(d('Sat Oct 29'), d('Mon Oct 31'))).to eq(13 * 3600)
        expect(seconds_in_date_range(d('Sat Oct 29'), d('Tue Nov 1'))).to eq(23 * 3600)
        expect(seconds_in_date_range(d('Sat Oct 29'), d('Wed Nov 2'))).to eq(32 * 3600)
        expect(seconds_in_date_range(d('Sat Oct 29'), d('Thu Nov 3'))).to eq(42 * 3600)
      end

      it 'returns seconds in ranges starting on a Sunday' do
        expect(seconds_in_date_range(d('Sun Oct 30'), d('Sun Oct 30'))).to eq(0)
        expect(seconds_in_date_range(d('Sun Oct 30'), d('Mon Oct 31'))).to eq(8 * 3600)
        expect(seconds_in_date_range(d('Sun Oct 30'), d('Tue Nov 1'))).to eq(18 * 3600)
        expect(seconds_in_date_range(d('Sun Oct 30'), d('Wed Nov 2'))).to eq(27 * 3600)
        expect(seconds_in_date_range(d('Sun Oct 30'), d('Thu Nov 3'))).to eq(37 * 3600)
        expect(seconds_in_date_range(d('Sun Oct 30'), d('Fri Nov 4'))).to eq(45 * 3600)
      end
    end

    describe 'dates more than a week apart' do
      def seconds_in_date_range(*args)
        options = {
          [:mon] => [[9 * 3600, 17 * 3600]],
          [:tue, :thu] => [[9 * 3600, 13 * 3600], [14 * 3600, 20 * 3600]],
          [:wed] => [[9 * 3600, 18 * 3600]],
          [:fri] => [[8 * 3600, 16 * 3600]],
          [:sat] => [[10 * 3600, 15 * 3600]]
        }

        described_class.new(options).seconds_in_date_range(*args)
      end

      it 'returns seconds in ranges starting on a Monday' do
        expect(seconds_in_date_range(d('Mon Oct 3'), d('Mon Oct 24'))).to eq(158 * 3600)
        expect(seconds_in_date_range(d('Mon Oct 3'), d('Tue Oct 25'))).to eq(168 * 3600)
        expect(seconds_in_date_range(d('Mon Oct 3'), d('Wed Oct 26'))).to eq(177 * 3600)
        expect(seconds_in_date_range(d('Mon Oct 3'), d('Thu Oct 27'))).to eq(187 * 3600)
        expect(seconds_in_date_range(d('Mon Oct 3'), d('Fri Oct 28'))).to eq(195 * 3600)
        expect(seconds_in_date_range(d('Mon Oct 3'), d('Sat Oct 29'))).to eq(200 * 3600)
        expect(seconds_in_date_range(d('Mon Oct 3'), d('Sun Oct 30'))).to eq(200 * 3600)
      end

      it 'returns seconds in ranges starting on a Tuesday' do
        expect(seconds_in_date_range(d('Tue Oct 4'), d('Tue Oct 25'))).to eq(160 * 3600)
        expect(seconds_in_date_range(d('Tue Oct 4'), d('Wed Oct 26'))).to eq(169 * 3600)
        expect(seconds_in_date_range(d('Tue Oct 4'), d('Thu Oct 27'))).to eq(179 * 3600)
        expect(seconds_in_date_range(d('Tue Oct 4'), d('Fri Oct 28'))).to eq(187 * 3600)
        expect(seconds_in_date_range(d('Tue Oct 4'), d('Sat Oct 29'))).to eq(192 * 3600)
        expect(seconds_in_date_range(d('Tue Oct 4'), d('Sun Oct 30'))).to eq(192 * 3600)
        expect(seconds_in_date_range(d('Tue Oct 4'), d('Mon Oct 31'))).to eq(200 * 3600)
      end

      it 'returns seconds in ranges starting on a Wednesday' do
        expect(seconds_in_date_range(d('Wed Oct 5'), d('Wed Oct 26'))).to eq(159 * 3600)
        expect(seconds_in_date_range(d('Wed Oct 5'), d('Thu Oct 27'))).to eq(169 * 3600)
        expect(seconds_in_date_range(d('Wed Oct 5'), d('Fri Oct 28'))).to eq(177 * 3600)
        expect(seconds_in_date_range(d('Wed Oct 5'), d('Sat Oct 29'))).to eq(182 * 3600)
        expect(seconds_in_date_range(d('Wed Oct 5'), d('Sun Oct 30'))).to eq(182 * 3600)
        expect(seconds_in_date_range(d('Wed Oct 5'), d('Mon Oct 31'))).to eq(190 * 3600)
        expect(seconds_in_date_range(d('Wed Oct 5'), d('Tue Nov 1'))).to eq(200 * 3600)
      end

      it 'returns seconds in ranges starting on a Thursday' do
        expect(seconds_in_date_range(d('Thu Oct 6'), d('Thu Oct 27'))).to eq(160 * 3600)
        expect(seconds_in_date_range(d('Thu Oct 6'), d('Fri Oct 28'))).to eq(168 * 3600)
        expect(seconds_in_date_range(d('Thu Oct 6'), d('Sat Oct 29'))).to eq(173 * 3600)
        expect(seconds_in_date_range(d('Thu Oct 6'), d('Sun Oct 30'))).to eq(173 * 3600)
        expect(seconds_in_date_range(d('Thu Oct 6'), d('Mon Oct 31'))).to eq(181 * 3600)
        expect(seconds_in_date_range(d('Thu Oct 6'), d('Tue Nov 1'))).to eq(191 * 3600)
        expect(seconds_in_date_range(d('Thu Oct 6'), d('Wed Nov 2'))).to eq(200 * 3600)
      end

      it 'returns seconds in ranges starting on a Friday' do
        expect(seconds_in_date_range(d('Fri Oct 7'), d('Fri Oct 28'))).to eq(158 * 3600)
        expect(seconds_in_date_range(d('Fri Oct 7'), d('Sat Oct 29'))).to eq(163 * 3600)
        expect(seconds_in_date_range(d('Fri Oct 7'), d('Sun Oct 30'))).to eq(163 * 3600)
        expect(seconds_in_date_range(d('Fri Oct 7'), d('Mon Oct 31'))).to eq(171 * 3600)
        expect(seconds_in_date_range(d('Fri Oct 7'), d('Tue Nov 1'))).to eq(181 * 3600)
        expect(seconds_in_date_range(d('Fri Oct 7'), d('Wed Nov 2'))).to eq(190 * 3600)
        expect(seconds_in_date_range(d('Fri Oct 7'), d('Thu Nov 3'))).to eq(200 * 3600)
      end

      it 'returns seconds in ranges starting on a Saturday' do
        expect(seconds_in_date_range(d('Sat Oct 8'), d('Sat Oct 29'))).to eq(155 * 3600)
        expect(seconds_in_date_range(d('Sat Oct 8'), d('Sun Oct 30'))).to eq(155 * 3600)
        expect(seconds_in_date_range(d('Sat Oct 8'), d('Mon Oct 31'))).to eq(163 * 3600)
        expect(seconds_in_date_range(d('Sat Oct 8'), d('Tue Nov 1'))).to eq(173 * 3600)
        expect(seconds_in_date_range(d('Sat Oct 8'), d('Wed Nov 2'))).to eq(182 * 3600)
        expect(seconds_in_date_range(d('Sat Oct 8'), d('Thu Nov 3'))).to eq(192 * 3600)
        expect(seconds_in_date_range(d('Sat Oct 8'), d('Fri Nov 4'))).to eq(200 * 3600)
      end

      it 'returns seconds in ranges starting on a Sunday' do
        expect(seconds_in_date_range(d('Sun Oct 9'), d('Sun Oct 30'))).to eq(150 * 3600)
        expect(seconds_in_date_range(d('Sun Oct 9'), d('Mon Oct 31'))).to eq(158 * 3600)
        expect(seconds_in_date_range(d('Sun Oct 9'), d('Tue Nov 1'))).to eq(168 * 3600)
        expect(seconds_in_date_range(d('Sun Oct 9'), d('Wed Nov 2'))).to eq(177 * 3600)
        expect(seconds_in_date_range(d('Sun Oct 9'), d('Thu Nov 3'))).to eq(187 * 3600)
        expect(seconds_in_date_range(d('Sun Oct 9'), d('Fri Nov 4'))).to eq(195 * 3600)
        expect(seconds_in_date_range(d('Sun Oct 9'), d('Sat Nov 5'))).to eq(200 * 3600)
      end
    end
  end

  describe '#seconds_since_beginning_of_day' do
    def seconds_since_beginning_of_day(*args)
      options = {
        [:mon] => [[9 * 3600, 17 * 3600]],
        [:tue, :thu] => [[9 * 3600, 13 * 3600], [14 * 3600, 20 * 3600]],
        [:wed] => [[9 * 3600, 18 * 3600]],
        [:fri] => [[8 * 3600, 16 * 3600]],
        [:sat] => [[10 * 3600, 14 * 3600]]
      }

      described_class.new(options).seconds_since_beginning_of_day(*args)
    end

    it 'returns the working time in seconds before given time' do
      expect(seconds_since_beginning_of_day(t('Mon Oct 31', '8:59'))).to eq(0)
      expect(seconds_since_beginning_of_day(t('Mon Oct 31', '10:00'))).to eq(3600)
      expect(seconds_since_beginning_of_day(t('Mon Oct 31', '16:00'))).to eq(7 * 3600)
      expect(seconds_since_beginning_of_day(t('Mon Oct 31', '19:00'))).to eq(8 * 3600)

      expect(seconds_since_beginning_of_day(t('Tue Nov 1', '8:59'))).to eq(0)
      expect(seconds_since_beginning_of_day(t('Tue Nov 1', '10:00'))).to eq(3600)
      expect(seconds_since_beginning_of_day(t('Tue Nov 1', '16:00'))).to eq(6 * 3600)
      expect(seconds_since_beginning_of_day(t('Tue Nov 1', '19:00'))).to eq(9 * 3600)
      expect(seconds_since_beginning_of_day(t('Tue Nov 1', '20:00'))).to eq(10 * 3600)

      expect(seconds_since_beginning_of_day(t('Wed Nov 2', '8:59'))).to eq(0)
      expect(seconds_since_beginning_of_day(t('Wed Nov 2', '10:00'))).to eq(3600)
      expect(seconds_since_beginning_of_day(t('Wed Nov 2', '16:00'))).to eq(7 * 3600)
      expect(seconds_since_beginning_of_day(t('Wed Nov 2', '19:00'))).to eq(9 * 3600)

      expect(seconds_since_beginning_of_day(t('Thu Nov 3', '8:59'))).to eq(0)
      expect(seconds_since_beginning_of_day(t('Thu Nov 3', '10:00'))).to eq(3600)
      expect(seconds_since_beginning_of_day(t('Thu Nov 3', '16:00'))).to eq(6 * 3600)
      expect(seconds_since_beginning_of_day(t('Thu Nov 3', '19:00'))).to eq(9 * 3600)
      expect(seconds_since_beginning_of_day(t('Thu Nov 3', '20:00'))).to eq(10 * 3600)

      expect(seconds_since_beginning_of_day(t('Fri Nov 4', '8:59'))).to eq(59 * 60)
      expect(seconds_since_beginning_of_day(t('Fri Nov 4', '10:00'))).to eq(2 * 3600)
      expect(seconds_since_beginning_of_day(t('Fri Nov 4', '16:00'))).to eq(8 * 3600)
      expect(seconds_since_beginning_of_day(t('Fri Nov 4', '19:00'))).to eq(8 * 3600)

      expect(seconds_since_beginning_of_day(t('Sat Nov 5', '10:00'))).to eq(0)
      expect(seconds_since_beginning_of_day(t('Sat Nov 5', '16:00'))).to eq(4 * 3600)
      expect(seconds_since_beginning_of_day(t('Sat Nov 5', '19:00'))).to eq(4 * 3600)

      expect(seconds_since_beginning_of_day(t('Sun Nov 6', '12:00'))).to eq(0)
      expect(seconds_since_beginning_of_day(t('Sun Nov 6', '19:00'))).to eq(0)
    end
  end

  describe '#seconds_until_end_of_day' do
    def seconds_until_end_of_day(*args)
      options = {
        [:mon] => [[9 * 3600, 17 * 3600]],
        [:tue, :thu] => [[9 * 3600, 13 * 3600], [14 * 3600, 20 * 3600]],
        [:wed] => [[9 * 3600, 18 * 3600]],
        [:fri] => [[8 * 3600, 16 * 3600]],
        [:sat] => [[10 * 3600, 14 * 3600]]
      }

      described_class.new(options).seconds_until_end_of_day(*args)
    end

    it 'returns the working time in after before given time' do
      expect(seconds_until_end_of_day(t('Mon Oct 31', '8:59'))).to eq(8 * 3600)
      expect(seconds_until_end_of_day(t('Mon Oct 31', '10:00'))).to eq(7 * 3600)
      expect(seconds_until_end_of_day(t('Mon Oct 31', '16:00'))).to eq(1 * 3600)
      expect(seconds_until_end_of_day(t('Mon Oct 31', '19:00'))).to eq(0)

      expect(seconds_until_end_of_day(t('Tue Nov 1', '8:59'))).to eq(10 * 3600)
      expect(seconds_until_end_of_day(t('Tue Nov 1', '10:00'))).to eq(9 * 3600)
      expect(seconds_until_end_of_day(t('Tue Nov 1', '16:00'))).to eq(4 * 3600)
      expect(seconds_until_end_of_day(t('Tue Nov 1', '19:00'))).to eq(1 * 3600)
      expect(seconds_until_end_of_day(t('Tue Nov 1', '20:00'))).to eq(0 * 3600)

      expect(seconds_until_end_of_day(t('Wed Nov 2', '8:59'))).to eq(9 * 3600)
      expect(seconds_until_end_of_day(t('Wed Nov 2', '10:00'))).to eq(8 * 3600)
      expect(seconds_until_end_of_day(t('Wed Nov 2', '16:00'))).to eq(2 * 3600)
      expect(seconds_until_end_of_day(t('Wed Nov 2', '19:00'))).to eq(0 * 3600)

      expect(seconds_until_end_of_day(t('Thu Nov 3', '8:59'))).to eq(10 * 3600)
      expect(seconds_until_end_of_day(t('Thu Nov 3', '10:00'))).to eq(9 * 3600)
      expect(seconds_until_end_of_day(t('Thu Nov 3', '16:00'))).to eq(4 * 3600)
      expect(seconds_until_end_of_day(t('Thu Nov 3', '19:00'))).to eq(1 * 3600)
      expect(seconds_until_end_of_day(t('Thu Nov 3', '20:00'))).to eq(0 * 3600)

      expect(seconds_until_end_of_day(t('Fri Nov 4', '7:59'))).to eq(8 * 3600)
      expect(seconds_until_end_of_day(t('Fri Nov 4', '10:00'))).to eq(6 * 3600)
      expect(seconds_until_end_of_day(t('Fri Nov 4', '16:00'))).to eq(0 * 3600)
      expect(seconds_until_end_of_day(t('Fri Nov 4', '19:00'))).to eq(0 * 3600)

      expect(seconds_until_end_of_day(t('Sat Nov 5', '10:00'))).to eq(4 * 3600)
      expect(seconds_until_end_of_day(t('Sat Nov 5', '16:00'))).to eq(0)
      expect(seconds_until_end_of_day(t('Sat Nov 5', '19:00'))).to eq(0)

      expect(seconds_until_end_of_day(t('Sun Nov 6', '12:00'))).to eq(0)
      expect(seconds_until_end_of_day(t('Sun Nov 6', '19:00'))).to eq(0)
    end
  end
end
