require 'spec_helper'

RSpec.describe ChacathuhuongBenchmarker::Configuration do
  let(:config) { described_class.new }

  describe '#initialize' do
    it 'sets default values' do
      expect(config.iterations).to eq(1)
      expect(config.warmup).to be true
      expect(config.reporter).to be_an_instance_of(ChacathuhuongBenchmarker::Reporters::ConsoleReporter)
      expect(config.output_path).to eq('log/benchmarks')

      # Load test defaults
      expect(config.load_test).to eq({
        concurrent_users: 10,
        duration: 60,
        timeout: 30
      })

      # Memory test defaults
      expect(config.memory_test).to eq({
        detailed: true,
        gc_stats: true
      })
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

    it 'allows reading and writing load_test configuration' do
      new_config = { concurrent_users: 20, duration: 120, timeout: 60 }
      config.load_test = new_config
      expect(config.load_test).to eq(new_config)
    end

    it 'allows reading and writing memory_test configuration' do
      new_config = { detailed: false, gc_stats: false }
      config.memory_test = new_config
      expect(config.memory_test).to eq(new_config)
    end
  end

  describe 'default reporter' do
    it 'is an instance of ConsoleReporter' do
      expect(config.reporter).to be_an_instance_of(ChacathuhuongBenchmarker::Reporters::ConsoleReporter)
    end
  end
end
