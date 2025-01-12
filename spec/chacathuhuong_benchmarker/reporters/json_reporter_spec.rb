require 'spec_helper'

RSpec.describe ChacathuhuongBenchmarker::Reporters::JsonReporter do
  describe '#report' do
    let(:results) { [{ label: 'Test', real: 0.1 }] }
    let(:output_path) { 'tmp/benchmark_results' }
    let(:file_path) { "#{output_path}/#{Time.now.to_i}.json" }

    before do
      allow(ChacathuhuongBenchmarker).to receive(:configuration).and_return(double(output_path: output_path))
      FileUtils.mkdir_p(output_path)
    end

    after do
      FileUtils.rm_rf(output_path)
    end

    it 'writes the benchmark results to a JSON file' do
      reporter = described_class.new
      reporter.report(results)

      expect(File.exist?(file_path)).to be true

      file_content = File.read(file_path)
      parsed_results = JSON.parse(file_content)

      expect(parsed_results).to eq([{ "label" => "Test", "real" => 0.1 }])
    end
  end
end
