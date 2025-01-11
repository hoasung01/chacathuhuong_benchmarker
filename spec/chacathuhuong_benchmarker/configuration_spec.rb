require 'spec_helper'

RSpec.describe ChacathuhuongBenchmarker::Configuration do
  let(:config) { described_class.new }

  describe '#initialize' do
    it 'sets default values' do
      expect(config.iterations).to eq(1)
      expect(config.warmup).to be true
      expect(config.reporter).to be_an_instance_of(ChacathuhuongBenchmarker::Reporters::ConsoleReporter)
      expect(config.output_path).to eq('log/benchmarks')
    end
  end

  describe 'attribute accessors' do
    it 'allows reading and writing iterations' do
      config.iterations = 5
      expect(config.iterations).to eq(5)
    end

    it 'allows reading and writing warmup' do
      config.warmup = false
      expect(config.warmup).to be false
    end

    it 'allows reading and writing reporter' do
      new_reporter = double('CustomReporter')
      config.reporter = new_reporter
      expect(config.reporter).to eq(new_reporter)
    end

    it 'allows reading and writing output_path' do
      config.output_path = 'custom/path'
      expect(config.output_path).to eq('custom/path')
    end
  end

  describe 'default reporter' do
    it 'is an instance of ConsoleReporter' do
      expect(config.reporter).to be_an_instance_of(ChacathuhuongBenchmarker::Reporters::ConsoleReporter)
    end
  end
end
