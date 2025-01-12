require 'spec_helper'

RSpec.describe ChacathuhuongBenchmarker::Reporters::BaseReporter do
  describe '#report' do
    it 'raises a NotImplementedError' do
      reporter = described_class.new
      expect { reporter.report([]) }.to raise_error(NotImplementedError)
    end
  end
end
