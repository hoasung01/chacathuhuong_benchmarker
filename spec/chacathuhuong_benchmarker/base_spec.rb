require 'spec_helper'

RSpec.describe ChacathuhuongBenchmarker::Base do
  let(:label) { 'Test Benchmark' }
  let(:options) { { iterations: 5 } }
  let(:configuration) { instance_double('ChacathuhuongBenchmarker::Configuration') }
  let(:benchmarker) { described_class.new(label, options) }
  let(:reporter) { double('reporter') }

  before do
    allow(ChacathuhuongBenchmarker).to receive(:configuration).and_return(configuration)
    allow(configuration).to receive(:iterations).and_return(10)
    allow(configuration).to receive(:warmup).and_return(false)
    allow(configuration).to receive(:reporter).and_return(reporter)
    allow(reporter).to receive(:report)
  end

  describe '#initialize' do
    it 'sets the label' do
      expect(benchmarker.label).to eq(label)
    end

    it 'merges options with default options' do
      expect(benchmarker.options[:iterations]).to eq(5)
    end

    context 'when no options are provided' do
      let(:benchmarker) { described_class.new(label) }

      it 'uses default options from configuration' do
        expect(benchmarker.options[:iterations]).to eq(10)
      end
    end
  end

  describe '#measure' do
    it 'runs the benchmark' do
      expect(Benchmark).to receive(:bmbm).and_yield(double('x').as_null_object)
      benchmarker.measure { 'test' }
    end

    it 'returns the benchmark results' do
      allow(Benchmark).to receive(:bmbm).and_return('results')
      expect(benchmarker.measure { 'test' }).to eq('results')
    end

    it 'returns nil when no block is given' do
      expect(benchmarker.measure).to be_nil
    end

    context 'when warmup is enabled' do
      before do
        allow(configuration).to receive(:warmup).and_return(true)
        allow(GC).to receive(:start)
      end

      it 'calls the warmup method and GC.start' do
        expect(GC).to receive(:start)
        expect(benchmarker).to receive(:warmup)
        benchmarker.measure { 'test' }
      end
    end

    context 'when iterations are specified' do
      it 'runs the specified number of iterations' do
        expect(Benchmark).to receive(:bmbm) do |&block|
          x = double('x')
          expect(x).to receive(:report).exactly(3).times
          block.call(x)
        end
        benchmarker.measure(3) { 'test' }
      end
    end

    context 'when reporter is nil' do
      before do
        allow(configuration).to receive(:reporter).and_return(nil)
      end

      it 'does not raise error' do
        expect { benchmarker.measure { 'test' } }.not_to raise_error
      end
    end
  end
end
