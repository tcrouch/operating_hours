require 'spec_helper'

describe BusinessTimeCalculator::HolidayCollection do
  describe 'between' do
    let(:schedule) do
      BusinessTimeCalculator::Schedule.new({
        [:mon, :tue, :wed, :thu, :fri] => [[9 * 3600, 17 * 3600]]
      })
    end

    def days_in_date_range(*args)
      holidays = [d('Sun Oct 30'), d('Tue Nov 1'), d('Tue Nov 8')]
      described_class.new(collection: holidays, schedule: schedule).days_in_date_range(*args)
    end

    it 'returns holidays between two days' do
      expect(days_in_date_range(d('Mon Oct 31'), d('Wed Nov 2'))).to eq(1)
    end

    it 'excludes holidays in weekends' do
      expect(days_in_date_range(d('Sat Oct 29'), d('Wed Nov 2'))).to eq(1)
    end

    it 'adds the edges' do
      expect(days_in_date_range(d('Tue Nov 1'), d('Thu Nov 3'))).to eq(1)
      expect(days_in_date_range(d('Sat Oct 29'), d('Tue Nov 1'))).to eq(1)
    end
  end

  describe 'seconds_in_date_range' do
    let(:schedule) do
      BusinessTimeCalculator::Schedule.new({
        [:mon, :tue] => [[9 * 3600, 17 * 3600]],
        [:wed, :thu, :fri] => [[9 * 3600, 18 * 3600]]
      })
    end

    def seconds_in_date_range(*args)
      holidays = [d('Sun Oct 30'), d('Tue Nov 1'), d('Wed Nov 9'), d('Thu Nov 17')]
      described_class.new(collection: holidays, schedule: schedule).seconds_in_date_range(*args)
    end

    it 'returns holiday seconds between two days' do
      expect(seconds_in_date_range(d('Mon Oct 31'), d('Thu Nov 10'))).to eq(17 * 3600)
    end

    it 'excludes holidays in weekends' do
      expect(seconds_in_date_range(d('Sat Oct 29'), d('Wed Nov 2'))).to eq(8 * 3600)
    end

    it 'adds the edges' do
      expect(seconds_in_date_range(d('Tue Nov 1'), d('Thu Nov 3'))).to eq(8 * 3600)
      expect(seconds_in_date_range(d('Sat Oct 29'), d('Tue Nov 1'))).to eq(8 * 3600)
    end
  end

  describe 'include?' do
    let(:schedule) do
      BusinessTimeCalculator::Schedule.new({
        [:mon, :tue, :wed, :thu, :fri] => [[9 * 3600, 17 * 3600]]
      })
    end

    def include?(*args)
      holidays = [d('Sun Oct 30'), d('Tue Nov 1'), d('Tue Nov 8')]
      described_class.new(collection: holidays, schedule: schedule).include?(*args)
    end

    it 'returns true if date is a holiday' do
      expect(include?(d('Tue Nov 1'))).to eq(true)
    end

    it 'returns false if date is not a holiday' do
      expect(include?(d('Wed Nov 2'))).to eq(false)
    end
  end
end
