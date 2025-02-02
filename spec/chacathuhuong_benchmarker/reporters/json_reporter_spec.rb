require 'spec_helper'

RSpec.describe ChacathuhuongBenchmarker::Reporters::JsonReporter do
  describe '#report' do
    let(:results) { [{ label: 'Test', real: 0.1 }] }
    let(:output_path) { 'tmp/benchmark_results' }
    let(:timestamp) { Time.now.to_i }
    let(:file_path) { "#{output_path}/benchmark_#{timestamp}.json" }

    before do
      allow(Time).to receive(:now).and_return(double(to_i: timestamp))
      allow(ChacathuhuongBenchmarker).to receive(:configuration).and_return(double(output_path: output_path))
      FileUtils.mkdir_p(output_path)
    end

    after do
      FileUtils.rm_rf(output_path)
    end

    context 'with valid results' do
      it 'writes the benchmark results to a JSON file' do
        reporter = described_class.new
        reporter.report(results)

        expect(File.exist?(file_path)).to be true
        expect(JSON.parse(File.read(file_path))).to eq([{ "label" => "Test", "real" => 0.1 }])
      end
    end

    context 'with empty results' do
      it 'does not create a file' do
        reporter = described_class.new
        reporter.report([])

        expect(File.exist?(file_path)).to be false
      end
    end
  end
end
