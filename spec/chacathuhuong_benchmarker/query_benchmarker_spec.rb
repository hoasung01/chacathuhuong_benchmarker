require 'spec_helper'
require 'chacathuhuong_benchmarker/query_benchmarker'

RSpec.describe ChacathuhuongBenchmarker::QueryBenchmarker do
  let(:config) { instance_double(ChacathuhuongBenchmarker::Configuration) }
  let(:benchmarker) { described_class.new(config) }

  describe '#measure_queries' do
    let(:query1) { { label: 'Query 1', block: -> { sleep(0.1) } } }
    let(:query2) { { label: 'Query 2', block: -> { sleep(0.2) } } }
    let(:mock_results) { [double('BenchmarkResult', label: 'Query 1'), double('BenchmarkResult', label: 'Query 2')] }

    before do
      allow(benchmarker).to receive(:report_results)
    end

    it 'uses Benchmark.bmbm to measure queries' do
      benchmark_double = double('Benchmark')
      allow(benchmark_double).to receive(:report).and_yield
      expect(Benchmark).to receive(:bmbm).and_yield(benchmark_double).and_return(mock_results)

      benchmarker.measure_queries(query1, query2)
    end

    it 'reports each query with its label' do
      benchmark_double = double('Benchmark')
      expect(Benchmark).to receive(:bmbm).and_yield(benchmark_double).and_return(mock_results)

      expect(benchmark_double).to receive(:report).with('Query 1').and_yield
      expect(benchmark_double).to receive(:report).with('Query 2').and_yield

      benchmarker.measure_queries(query1, query2)
    end

    it 'calls the block for each query' do
      benchmark_double = double('Benchmark')
      allow(benchmark_double).to receive(:report).and_yield
      allow(Benchmark).to receive(:bmbm).and_yield(benchmark_double).and_return(mock_results)

      expect(query1[:block]).to receive(:call)
      expect(query2[:block]).to receive(:call)

      benchmarker.measure_queries(query1, query2)
    end

    it 'calls report_results with the benchmark results' do
      benchmark_double = double('Benchmark')
      allow(benchmark_double).to receive(:report).and_yield
      allow(Benchmark).to receive(:bmbm).and_yield(benchmark_double).and_return(mock_results)

      expect(benchmarker).to receive(:report_results).with(mock_results)
      benchmarker.measure_queries(query1, query2)
    end
  end
end
