require 'spec_helper'

describe BetterBusinessTime::Days do
  describe '.between' do
    def described_method(*args)
      described_class.between(*args)
    end

    it 'returns business days between two dates' do
      expect(described_method(date('Mon Oct 31'), date('Fri Nov 4'))).to eq(4)
      expect(described_method(date('Mon Oct 31'), date('Sat Nov 5'))).to eq(4)
      expect(described_method(date('Mon Oct 31'), date('Sun Nov 6'))).to eq(4)
      expect(described_method(date('Fri Nov 4'), date('Mon Nov 7'))).to eq(1)
      expect(described_method(date('Sat Nov 5'), date('Mon Nov 7'))).to eq(0)
      expect(described_method(date('Sun Nov 6'), date('Mon Nov 7'))).to eq(0)
    end

    it 'excludes holidays' do
      BetterBusinessTime::WeekdayHolidays
        .set([date('Sun Oct 30'), date('Tue Nov 1'), date('Tue Nov 8')])
      expect(described_method(date('Mon Oct 31'), date('Fri Nov 4'))).to eq(3)
      expect(described_method(date('Tue Nov 1'), date('Fri Nov 4'))).to eq(2)
    end
  end

  describe '.weekend_days_between' do
    def described_method(*args)
      described_class.weekend_days_between(*args)
    end

    describe 'when distance < 1 week' do
      it 'returns 0 between monday and friday' do
        expect(described_method(date('Mon Oct 31'), date('Fri Nov 4'))).to eq(0)
        expect(described_method(date('Sat Nov 5'), date('Thu Nov 3'))).to eq(0)
        expect(described_method(date('Wed Nov 2'), date('Thu Nov 3'))).to eq(0)
      end

      it 'returns 1 if one of the two falls on a weekend' do
        expect(described_method(date('Sun Oct 30'), date('Fri Nov 4'))).to eq(1)
        expect(described_method(date('Sun Oct 30'), date('Mon Oct 31'))).to eq(1)
        expect(described_method(date('Mon Oct 31'), date('Sat Nov 5'))).to eq(1)
        expect(described_method(date('Fri Nov 4'), date('Sat Nov 5'))).to eq(1)
      end

      it 'returns 2 if both fall on a weekend' do
        expect(described_method(date('Sat Oct 29'), date('Sun Oct 30'))).to eq(2)
        expect(described_method(date('Sun Oct 30'), date('Sat Nov 5'))).to eq(2)
      end
    end

    describe 'when distance > 1 week' do
      it 'returns 4 between monday and friday' do
        expect(described_method(date('Mon Oct 17'), date('Fri Nov 4'))).to eq(4)
        expect(described_method(date('Tue Oct 18'), date('Thu Nov 3'))).to eq(4)
        expect(described_method(date('Wed Oct 19'), date('Thu Nov 3'))).to eq(4)
      end

      it 'returns 5 if one of the two falls on a weekend' do
        expect(described_method(date('Sun Oct 16'), date('Fri Nov 4'))).to eq(5)
        expect(described_method(date('Sun Oct 16'), date('Mon Oct 31'))).to eq(5)
        expect(described_method(date('Mon Oct 17'), date('Sat Nov 5'))).to eq(5)
        expect(described_method(date('Fri Oct 21'), date('Sat Nov 5'))).to eq(5)
      end

      it 'returns 6 if both fall on a weekend' do
        expect(described_method(date('Sat Oct 15'), date('Sun Oct 30'))).to eq(6)
        expect(described_method(date('Sun Oct 16'), date('Sat Nov 5'))).to eq(6)
      end
    end
  end
end
