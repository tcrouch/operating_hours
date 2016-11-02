require 'spec_helper'

describe BusinessTimeCalculator::HolidayCollection do
  describe 'between' do
    def between(*args)
      holidays = [d('Sun Oct 30'), d('Tue Nov 1'), d('Tue Nov 8')]
      described_class.new(holidays).between(*args)
    end

    it 'returns holidays between two days' do
      expect(between(d('Mon Oct 31'), d('Wed Nov 2'))).to eq(1)
    end

    it 'excludes holidays in weekends' do
      expect(between(d('Sat Oct 29'), d('Wed Nov 2'))).to eq(1)
    end

    it 'adds the edges' do
      expect(between(d('Tue Nov 1'), d('Thu Nov 3'))).to eq(1)
      expect(between(d('Sat Oct 29'), d('Tue Nov 1'))).to eq(1)
    end
  end

  describe 'include?' do
    def include?(*args)
      holidays = [d('Sun Oct 30'), d('Tue Nov 1'), d('Tue Nov 8')]
      described_class.new(holidays).include?(*args)
    end

    it 'returns true if date is a holiday' do
      expect(include?(d('Tue Nov 1'))).to eq(true)
    end

    it 'returns false if date is not a holiday' do
      expect(include?(d('Wed Nov 2'))).to eq(false)
    end
  end
end
