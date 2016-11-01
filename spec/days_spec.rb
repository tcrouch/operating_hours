require 'spec_helper'

describe BetterBusinessTime::Days do
  describe '.between' do
    def described_method(*args)
      described_class.between(*args)
    end

    it 'returns business days between two dates starting Monday' do
      expect(described_method(d('Mon Oct 31'), d('Mon Oct 31'))).to eq(1)
      expect(described_method(d('Mon Oct 31'), d('Tue Nov 1'))).to eq(2)
      expect(described_method(d('Mon Oct 31'), d('Wed Nov 2'))).to eq(3)
      expect(described_method(d('Mon Oct 31'), d('Thu Nov 3'))).to eq(4)
      expect(described_method(d('Mon Oct 31'), d('Fri Nov 4'))).to eq(5)
      expect(described_method(d('Mon Oct 31'), d('Sat Nov 5'))).to eq(5)
      expect(described_method(d('Mon Oct 31'), d('Sun Nov 6'))).to eq(5)
      expect(described_method(d('Mon Oct 31'), d('Mon Nov 7'))).to eq(6)
    end

    it 'returns business days between two dates starting Tuesday' do
      expect(described_method(d('Tue Nov 1'), d('Tue Nov 1'))).to eq(1)
      expect(described_method(d('Tue Nov 1'), d('Wed Nov 2'))).to eq(2)
      expect(described_method(d('Tue Nov 1'), d('Thu Nov 3'))).to eq(3)
      expect(described_method(d('Tue Nov 1'), d('Fri Nov 4'))).to eq(4)
      expect(described_method(d('Tue Nov 1'), d('Sat Nov 5'))).to eq(4)
      expect(described_method(d('Tue Nov 1'), d('Sun Nov 6'))).to eq(4)
      expect(described_method(d('Tue Nov 1'), d('Mon Nov 7'))).to eq(5)
      expect(described_method(d('Tue Nov 1'), d('Tue Nov 8'))).to eq(6)
    end

    it 'returns business days between two dates starting Wednesday' do
      expect(described_method(d('Wed Nov 2'), d('Wed Nov 2'))).to eq(1)
      expect(described_method(d('Wed Nov 2'), d('Thu Nov 3'))).to eq(2)
      expect(described_method(d('Wed Nov 2'), d('Fri Nov 4'))).to eq(3)
      expect(described_method(d('Wed Nov 2'), d('Sat Nov 5'))).to eq(3)
      expect(described_method(d('Wed Nov 2'), d('Sun Nov 6'))).to eq(3)
      expect(described_method(d('Wed Nov 2'), d('Mon Nov 7'))).to eq(4)
      expect(described_method(d('Wed Nov 2'), d('Tue Nov 8'))).to eq(5)
      expect(described_method(d('Wed Nov 2'), d('Wed Nov 9'))).to eq(6)
    end

    it 'returns business days between two dates starting Thursday' do
      expect(described_method(d('Thu Nov 3'), d('Thu Nov 3'))).to eq(1)
      expect(described_method(d('Thu Nov 3'), d('Fri Nov 4'))).to eq(2)
      expect(described_method(d('Thu Nov 3'), d('Sat Nov 5'))).to eq(2)
      expect(described_method(d('Thu Nov 3'), d('Sun Nov 6'))).to eq(2)
      expect(described_method(d('Thu Nov 3'), d('Mon Nov 7'))).to eq(3)
      expect(described_method(d('Thu Nov 3'), d('Tue Nov 8'))).to eq(4)
      expect(described_method(d('Thu Nov 3'), d('Wed Nov 9'))).to eq(5)
      expect(described_method(d('Thu Nov 3'), d('Thu Nov 10'))).to eq(6)
    end

    it 'returns business days between two dates starting Friday' do
      expect(described_method(d('Fri Nov 4'), d('Fri Nov 4'))).to eq(1)
      expect(described_method(d('Fri Nov 4'), d('Sat Nov 5'))).to eq(1)
      expect(described_method(d('Fri Nov 4'), d('Sun Nov 6'))).to eq(1)
      expect(described_method(d('Fri Nov 4'), d('Mon Nov 7'))).to eq(2)
      expect(described_method(d('Fri Nov 4'), d('Tue Nov 8'))).to eq(3)
      expect(described_method(d('Fri Nov 4'), d('Wed Nov 9'))).to eq(4)
      expect(described_method(d('Fri Nov 4'), d('Thu Nov 10'))).to eq(5)
      expect(described_method(d('Fri Nov 4'), d('Fri Nov 11'))).to eq(6)
    end

    it 'returns business days between two dates starting Saturday' do
      expect(described_method(d('Sat Nov 5'), d('Sat Nov 5'))).to eq(0)
      expect(described_method(d('Sat Nov 5'), d('Sun Nov 6'))).to eq(0)
      expect(described_method(d('Sat Nov 5'), d('Mon Nov 7'))).to eq(1)
      expect(described_method(d('Sat Nov 5'), d('Tue Nov 8'))).to eq(2)
      expect(described_method(d('Sat Nov 5'), d('Wed Nov 9'))).to eq(3)
      expect(described_method(d('Sat Nov 5'), d('Thu Nov 10'))).to eq(4)
      expect(described_method(d('Sat Nov 5'), d('Fri Nov 11'))).to eq(5)
      expect(described_method(d('Sat Nov 5'), d('Sat Nov 12'))).to eq(5)
    end

    it 'returns business days between two dates starting Sunday' do
      expect(described_method(d('Sun Nov 6'), d('Sun Nov 6'))).to eq(0)
      expect(described_method(d('Sun Nov 6'), d('Mon Nov 7'))).to eq(1)
      expect(described_method(d('Sun Nov 6'), d('Tue Nov 8'))).to eq(2)
      expect(described_method(d('Sun Nov 6'), d('Wed Nov 9'))).to eq(3)
      expect(described_method(d('Sun Nov 6'), d('Thu Nov 10'))).to eq(4)
      expect(described_method(d('Sun Nov 6'), d('Fri Nov 11'))).to eq(5)
      expect(described_method(d('Sun Nov 6'), d('Sat Nov 12'))).to eq(5)
      expect(described_method(d('Sun Nov 6'), d('Sun Nov 13'))).to eq(5)
    end

    it 'excludes holidays' do
      BetterBusinessTime::WeekdayHolidays
        .set([d('Sun Oct 30'), d('Tue Nov 1'), d('Wed Nov 9')])
      expect(described_method(d('Mon Oct 31'), d('Mon Oct 31'))).to eq(1)
      expect(described_method(d('Mon Oct 31'), d('Tue Nov 1'))).to eq(1)
      expect(described_method(d('Mon Oct 31'), d('Wed Nov 2'))).to eq(2)
      expect(described_method(d('Mon Oct 31'), d('Thu Nov 3'))).to eq(3)
      expect(described_method(d('Mon Oct 31'), d('Fri Nov 4'))).to eq(4)
      expect(described_method(d('Mon Oct 31'), d('Sat Nov 5'))).to eq(4)
      expect(described_method(d('Mon Oct 31'), d('Sun Nov 6'))).to eq(4)
      expect(described_method(d('Mon Oct 31'), d('Mon Nov 7'))).to eq(5)
    end
  end

  describe '.weekend_days_between' do
    def described_method(*args)
      described_class.weekend_days_between(*args)
    end

    describe 'when distance <= 1 week' do
      it 'returns weekend days between Monday and another date' do
        expect(described_method(d('Mon Nov 7'), d('Mon Nov 7'))).to eq(0)
        expect(described_method(d('Mon Nov 7'), d('Tue Nov 8'))).to eq(0)
        expect(described_method(d('Mon Nov 7'), d('Wed Nov 9'))).to eq(0)
        expect(described_method(d('Mon Nov 7'), d('Thu Nov 10'))).to eq(0)
        expect(described_method(d('Mon Nov 7'), d('Fri Nov 11'))).to eq(0)
        expect(described_method(d('Mon Nov 7'), d('Sat Nov 12'))).to eq(1)
        expect(described_method(d('Mon Nov 7'), d('Sun Nov 13'))).to eq(2)
        expect(described_method(d('Mon Nov 7'), d('Mon Nov 14'))).to eq(2)
      end

      it 'returns weekend days between Tuesday and another date' do
        expect(described_method(d('Tue Nov 8'), d('Tue Nov 8'))).to eq(0)
        expect(described_method(d('Tue Nov 8'), d('Wed Nov 9'))).to eq(0)
        expect(described_method(d('Tue Nov 8'), d('Thu Nov 10'))).to eq(0)
        expect(described_method(d('Tue Nov 8'), d('Fri Nov 11'))).to eq(0)
        expect(described_method(d('Tue Nov 8'), d('Sat Nov 12'))).to eq(1)
        expect(described_method(d('Tue Nov 8'), d('Sun Nov 13'))).to eq(2)
        expect(described_method(d('Tue Nov 8'), d('Mon Nov 14'))).to eq(2)
        expect(described_method(d('Tue Nov 8'), d('Tue Nov 15'))).to eq(2)
      end

      it 'returns weekend days between Wednesday and another date' do
        expect(described_method(d('Wed Nov 9'), d('Wed Nov 9'))).to eq(0)
        expect(described_method(d('Wed Nov 9'), d('Thu Nov 10'))).to eq(0)
        expect(described_method(d('Wed Nov 9'), d('Fri Nov 11'))).to eq(0)
        expect(described_method(d('Wed Nov 9'), d('Sat Nov 12'))).to eq(1)
        expect(described_method(d('Wed Nov 9'), d('Sun Nov 13'))).to eq(2)
        expect(described_method(d('Wed Nov 9'), d('Mon Nov 14'))).to eq(2)
        expect(described_method(d('Wed Nov 9'), d('Tue Nov 15'))).to eq(2)
        expect(described_method(d('Wed Nov 9'), d('Wed Nov 16'))).to eq(2)
      end

      it 'returns weekend days between Thursday and another date' do
        expect(described_method(d('Thu Nov 10'), d('Thu Nov 10'))).to eq(0)
        expect(described_method(d('Thu Nov 10'), d('Fri Nov 11'))).to eq(0)
        expect(described_method(d('Thu Nov 10'), d('Sat Nov 12'))).to eq(1)
        expect(described_method(d('Thu Nov 10'), d('Sun Nov 13'))).to eq(2)
        expect(described_method(d('Thu Nov 10'), d('Mon Nov 14'))).to eq(2)
        expect(described_method(d('Thu Nov 10'), d('Tue Nov 15'))).to eq(2)
        expect(described_method(d('Thu Nov 10'), d('Wed Nov 16'))).to eq(2)
        expect(described_method(d('Thu Nov 10'), d('Thu Nov 17'))).to eq(2)
      end

      it 'returns weekend days between Friday and another date' do
        expect(described_method(d('Fri Nov 11'), d('Fri Nov 11'))).to eq(0)
        expect(described_method(d('Fri Nov 11'), d('Sat Nov 12'))).to eq(1)
        expect(described_method(d('Fri Nov 11'), d('Sun Nov 13'))).to eq(2)
        expect(described_method(d('Fri Nov 11'), d('Mon Nov 14'))).to eq(2)
        expect(described_method(d('Fri Nov 11'), d('Tue Nov 15'))).to eq(2)
        expect(described_method(d('Fri Nov 11'), d('Wed Nov 16'))).to eq(2)
        expect(described_method(d('Fri Nov 11'), d('Thu Nov 17'))).to eq(2)
        expect(described_method(d('Fri Nov 11'), d('Fri Nov 18'))).to eq(2)
      end

      it 'returns weekend days between Saturday and another day' do
        expect(described_method(d('Sat Nov 5'), d('Sat Nov 5'))).to eq(1)
        expect(described_method(d('Sat Nov 5'), d('Sun Nov 6'))).to eq(2)
        expect(described_method(d('Sat Nov 5'), d('Mon Nov 7'))).to eq(2)
        expect(described_method(d('Sat Nov 5'), d('Tue Nov 8'))).to eq(2)
        expect(described_method(d('Sat Nov 5'), d('Wed Nov 9'))).to eq(2)
        expect(described_method(d('Sat Nov 5'), d('Thu Nov 10'))).to eq(2)
        expect(described_method(d('Sat Nov 5'), d('Fri Nov 11'))).to eq(2)
        expect(described_method(d('Sat Nov 5'), d('Sat Nov 12'))).to eq(3)
      end

      it 'returns weekend days between two dates starting Sunday' do
        expect(described_method(d('Sun Nov 6'), d('Sun Nov 6'))).to eq(1)
        expect(described_method(d('Sun Nov 6'), d('Mon Nov 7'))).to eq(1)
        expect(described_method(d('Sun Nov 6'), d('Tue Nov 8'))).to eq(1)
        expect(described_method(d('Sun Nov 6'), d('Wed Nov 9'))).to eq(1)
        expect(described_method(d('Sun Nov 6'), d('Thu Nov 10'))).to eq(1)
        expect(described_method(d('Sun Nov 6'), d('Fri Nov 11'))).to eq(1)
        expect(described_method(d('Sun Nov 6'), d('Sat Nov 12'))).to eq(2)
        expect(described_method(d('Sun Nov 6'), d('Sun Nov 13'))).to eq(3)
      end
    end

    describe 'when distance > 1 week' do
      it 'returns weekend days between Monday and another date' do
        expect(described_method(d('Mon Nov 7'), d('Mon Nov 21'))).to eq(4)
        expect(described_method(d('Mon Nov 7'), d('Tue Nov 22'))).to eq(4)
        expect(described_method(d('Mon Nov 7'), d('Wed Nov 23'))).to eq(4)
        expect(described_method(d('Mon Nov 7'), d('Thu Nov 24'))).to eq(4)
        expect(described_method(d('Mon Nov 7'), d('Fri Nov 25'))).to eq(4)
        expect(described_method(d('Mon Nov 7'), d('Sat Nov 26'))).to eq(5)
        expect(described_method(d('Mon Nov 7'), d('Sun Nov 27'))).to eq(6)
        expect(described_method(d('Mon Nov 7'), d('Mon Nov 28'))).to eq(6)
      end

      it 'returns weekend days between Tuesday and another date' do
        expect(described_method(d('Tue Nov 1'), d('Tue Nov 15'))).to eq(4)
        expect(described_method(d('Tue Nov 1'), d('Wed Nov 16'))).to eq(4)
        expect(described_method(d('Tue Nov 1'), d('Thu Nov 17'))).to eq(4)
        expect(described_method(d('Tue Nov 1'), d('Fri Nov 18'))).to eq(4)
        expect(described_method(d('Tue Nov 1'), d('Sat Nov 19'))).to eq(5)
        expect(described_method(d('Tue Nov 1'), d('Sun Nov 20'))).to eq(6)
        expect(described_method(d('Tue Nov 1'), d('Mon Nov 21'))).to eq(6)
        expect(described_method(d('Tue Nov 1'), d('Tue Nov 22'))).to eq(6)
      end

      it 'returns weekend days between Wednesday and another date' do
        expect(described_method(d('Wed Nov 2'), d('Wed Nov 16'))).to eq(4)
        expect(described_method(d('Wed Nov 2'), d('Thu Nov 17'))).to eq(4)
        expect(described_method(d('Wed Nov 2'), d('Fri Nov 18'))).to eq(4)
        expect(described_method(d('Wed Nov 2'), d('Sat Nov 19'))).to eq(5)
        expect(described_method(d('Wed Nov 2'), d('Sun Nov 20'))).to eq(6)
        expect(described_method(d('Wed Nov 2'), d('Mon Nov 21'))).to eq(6)
        expect(described_method(d('Wed Nov 2'), d('Tue Nov 22'))).to eq(6)
        expect(described_method(d('Wed Nov 2'), d('Wed Nov 23'))).to eq(6)
      end

      it 'returns weekend days between Thursday and another date' do
        expect(described_method(d('Thu Nov 3'), d('Thu Nov 17'))).to eq(4)
        expect(described_method(d('Thu Nov 3'), d('Fri Nov 18'))).to eq(4)
        expect(described_method(d('Thu Nov 3'), d('Sat Nov 19'))).to eq(5)
        expect(described_method(d('Thu Nov 3'), d('Sun Nov 20'))).to eq(6)
        expect(described_method(d('Thu Nov 3'), d('Mon Nov 21'))).to eq(6)
        expect(described_method(d('Thu Nov 3'), d('Tue Nov 22'))).to eq(6)
        expect(described_method(d('Thu Nov 3'), d('Wed Nov 23'))).to eq(6)
        expect(described_method(d('Thu Nov 3'), d('Thu Nov 24'))).to eq(6)
      end

      it 'returns weekend days between Friday and another date' do
        expect(described_method(d('Fri Nov 4'), d('Fri Nov 18'))).to eq(4)
        expect(described_method(d('Fri Nov 4'), d('Sat Nov 19'))).to eq(5)
        expect(described_method(d('Fri Nov 4'), d('Sun Nov 20'))).to eq(6)
        expect(described_method(d('Fri Nov 4'), d('Mon Nov 21'))).to eq(6)
        expect(described_method(d('Fri Nov 4'), d('Tue Nov 22'))).to eq(6)
        expect(described_method(d('Fri Nov 4'), d('Wed Nov 23'))).to eq(6)
        expect(described_method(d('Fri Nov 4'), d('Thu Nov 24'))).to eq(6)
        expect(described_method(d('Fri Nov 4'), d('Fri Nov 25'))).to eq(6)
      end

      it 'returns weekend days between Sunday and another date' do
        expect(described_method(d('Sat Nov 5'), d('Sat Nov 19'))).to eq(5)
        expect(described_method(d('Sat Nov 5'), d('Sun Nov 20'))).to eq(6)
        expect(described_method(d('Sat Nov 5'), d('Mon Nov 21'))).to eq(6)
        expect(described_method(d('Sat Nov 5'), d('Tue Nov 22'))).to eq(6)
        expect(described_method(d('Sat Nov 5'), d('Wed Nov 23'))).to eq(6)
        expect(described_method(d('Sat Nov 5'), d('Thu Nov 24'))).to eq(6)
        expect(described_method(d('Sat Nov 5'), d('Fri Nov 25'))).to eq(6)
        expect(described_method(d('Sat Nov 5'), d('Sat Nov 26'))).to eq(7)
      end

      it 'returns weekend days between Sunday and another date' do
        expect(described_method(d('Sun Nov 6'), d('Sun Nov 20'))).to eq(5)
        expect(described_method(d('Sun Nov 6'), d('Mon Nov 21'))).to eq(5)
        expect(described_method(d('Sun Nov 6'), d('Tue Nov 22'))).to eq(5)
        expect(described_method(d('Sun Nov 6'), d('Wed Nov 23'))).to eq(5)
        expect(described_method(d('Sun Nov 6'), d('Thu Nov 24'))).to eq(5)
        expect(described_method(d('Sun Nov 6'), d('Fri Nov 25'))).to eq(5)
        expect(described_method(d('Sun Nov 6'), d('Sat Nov 26'))).to eq(6)
        expect(described_method(d('Sun Nov 6'), d('Sun Nov 27'))).to eq(7)
      end
    end
  end
end
