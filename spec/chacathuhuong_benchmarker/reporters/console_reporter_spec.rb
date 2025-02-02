require 'spec_helper'

RSpec.describe ChacathuhuongBenchmarker::Reporters::ConsoleReporter do
  describe '#report' do
    it 'prints the benchmark results to the console' do
      reporter = described_class.new
      results = [{ label: 'Test', real: 0.1 }]

      expect($stdout).to receive(:puts).with("\n=== Benchmark Results ===")
      expect($stdout).to receive(:puts).with(results)
      expect($stdout).to receive(:puts).with("=== End of Results ===\n")

      reporter.report(results)
    end
  end
end
