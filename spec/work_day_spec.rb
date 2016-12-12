require 'spec_helper'

describe OperatingHours::WorkDay do
  describe '#seconds' do
    it 'returns the number of seconds in the day' do
      work_day = described_class.new([[9 * 3600, 17 * 3600]])
      expect(work_day.seconds).to eq(8 * 3600)

      work_day = described_class.new([[9 * 3600, 13 * 3600], [14 * 3600, 17 * 3600]])
      expect(work_day.seconds).to eq(7 * 3600)
    end
  end
end
