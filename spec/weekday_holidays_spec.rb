require 'spec_helper'

describe BetterBusinessTime::WeekdayHolidays do
  before do
    described_class.set([d('Sun Oct 30'), d('Tue Nov 1'), d('Tue Nov 8')])
  end

  describe 'between' do
    def described_method(*args)
      described_class.between(*args)
    end

    it 'returns holidays between two days' do
      expect(described_method(d('Mon Oct 31'), d('Wed Nov 2'))).to eq(1)
    end

    it 'excludes holidays in weekends' do
      expect(described_method(d('Sat Oct 29'), d('Wed Nov 2'))).to eq(1)
    end

    it 'adds the edges' do
      expect(described_method(d('Tue Nov 1'), d('Thu Nov 3'))).to eq(1)
      expect(described_method(d('Sat Oct 29'), d('Tue Nov 1'))).to eq(1)
    end
  end
end
