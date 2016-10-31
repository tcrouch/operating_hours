require 'spec_helper'

describe BetterBusinessTime::WeekdayHolidays do
  before do
    described_class.set([date('Sun Oct 30'), date('Tue Nov 1'), date('Tue Nov 8')])
  end

  describe 'between' do
    def described_method(*args)
      described_class.between(*args)
    end

    it 'returns holidays between two dates' do
      expect(described_method(date('Mon Oct 31'), date('Wed Nov 2'))).to eq(1)
    end

    it 'excludes holidays in weekends' do
      expect(described_method(date('Sat Oct 29'), date('Wed Nov 2'))).to eq(1)
    end

    it 'adds the extremes' do
      expect(described_method(date('Tue Nov 1'), date('Thu Nov 3'))).to eq(1)
      expect(described_method(date('Sat Oct 29'), date('Tue Nov 1'))).to eq(1)
    end
  end
end
