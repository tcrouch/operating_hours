require 'spec_helper'

describe BetterBusinessTime::Days do
  describe '.between' do
    def described_method(*args)
      described_class.between(*args)
    end

    it 'returns business days between two dates' do
      expect(described_method(d('Mon Oct 31'), d('Mon Oct 31'))).to eq(0)
      expect(described_method(d('Mon Oct 31'), d('Tue Nov 1'))).to eq(0)
      expect(described_method(d('Mon Oct 31'), d('Wed Nov 2'))).to eq(1)
      expect(described_method(d('Mon Oct 31'), d('Thu Nov 3'))).to eq(2)
      expect(described_method(d('Mon Oct 31'), d('Fri Nov 4'))).to eq(3)
      expect(described_method(d('Mon Oct 31'), d('Sat Nov 5'))).to eq(4)
      expect(described_method(d('Mon Oct 31'), d('Sun Nov 6'))).to eq(4)
      expect(described_method(d('Mon Oct 31'), d('Mon Nov 7'))).to eq(4)
      expect(described_method(d('Sun Nov 6'), d('Mon Nov 7'))).to eq(0)
      expect(described_method(d('Sat Nov 5'), d('Mon Nov 7'))).to eq(0)
      expect(described_method(d('Fri Nov 4'), d('Mon Nov 7'))).to eq(0)
    end

    it 'excludes holidays' do
      BetterBusinessTime::WeekdayHolidays
        .set([d('Sun Oct 30'), d('Tue Nov 1'), d('Tue Nov 8')])
      expect(described_method(d('Mon Oct 31'), d('Mon Oct 31'))).to eq(0)
      expect(described_method(d('Mon Oct 31'), d('Tue Nov 1'))).to eq(0)
      expect(described_method(d('Mon Oct 31'), d('Wed Nov 2'))).to eq(0)
      expect(described_method(d('Mon Oct 31'), d('Thu Nov 3'))).to eq(1)
      expect(described_method(d('Mon Oct 31'), d('Fri Nov 4'))).to eq(2)
      expect(described_method(d('Mon Oct 31'), d('Sat Nov 5'))).to eq(3)
      expect(described_method(d('Mon Oct 31'), d('Sun Nov 6'))).to eq(3)
      expect(described_method(d('Mon Oct 31'), d('Mon Nov 7'))).to eq(3)
      expect(described_method(d('Tue Nov 1'), d('Thu Nov 3'))).to eq(1)
    end
  end

  describe '.weekend_days_between' do
    def described_method(*args)
      described_class.weekend_days_between(*args)
    end

    describe 'when distance < 1 week' do
      it 'returns weekend days in the time period' do
        expect(described_method(d('Fri Oct 28'), d('Mon Oct 31'))).to eq(2)
        expect(described_method(d('Sat Oct 29'), d('Mon Oct 31'))).to eq(1)
        expect(described_method(d('Sun Oct 30'), d('Mon Oct 31'))).to eq(0)
        expect(described_method(d('Mon Oct 31'), d('Mon Oct 31'))).to eq(0)
        expect(described_method(d('Mon Oct 31'), d('Tue Nov 1'))).to eq(0)
        expect(described_method(d('Mon Oct 31'), d('Wed Nov 2'))).to eq(0)
        expect(described_method(d('Mon Oct 31'), d('Thu Nov 3'))).to eq(0)
        expect(described_method(d('Mon Oct 31'), d('Fri Nov 4'))).to eq(0)
        expect(described_method(d('Mon Oct 31'), d('Sat Nov 5'))).to eq(0)
        expect(described_method(d('Mon Oct 31'), d('Sun Nov 6'))).to eq(1)
        expect(described_method(d('Mon Oct 31'), d('Mon Nov 7'))).to eq(2)
      end
    end

    describe 'when distance > 1 week' do
      it 'returns 4 between monday and friday' do
        expect(described_method(d('Mon Oct 17'), d('Fri Nov 4'))).to eq(4)
        expect(described_method(d('Tue Oct 18'), d('Thu Nov 3'))).to eq(4)
        expect(described_method(d('Wed Oct 19'), d('Thu Nov 3'))).to eq(4)
      end

      it 'returns 5 if one of the two falls on a weekend' do
        expect(described_method(d('Sat Oct 15'), d('Fri Nov 4'))).to eq(5)
        expect(described_method(d('Sat Oct 15'), d('Mon Oct 31'))).to eq(5)
        expect(described_method(d('Mon Oct 17'), d('Sun Nov 6'))).to eq(5)
        expect(described_method(d('Fri Oct 21'), d('Sun Nov 6'))).to eq(5)
      end

      it 'returns 6 if both fall on a weekend' do
        expect(described_method(d('Fri Oct 14'), d('Mon Oct 31'))).to eq(6)
        expect(described_method(d('Sat Oct 15'), d('Sun Nov 6'))).to eq(6)
      end
    end
  end
end
