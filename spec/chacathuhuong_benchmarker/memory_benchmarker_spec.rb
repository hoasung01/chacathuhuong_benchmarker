require 'spec_helper'
require 'chacathuhuong_benchmarker/memory_benchmarker'
require 'get_process_mem'

RSpec.describe ChacathuhuongBenchmarker::MemoryBenchmarker do
  let(:label) { "Memory Test" }
  let(:options) { { gc_stats: true } }
  let(:benchmarker) { described_class.new(label, options) }

  describe '#initialize' do
    it 'sets the label and options' do
      expect(benchmarker.label).to eq(label)
      expect(benchmarker.options).to include(gc_stats: true)
    end
  end

  describe '#measure' do
    let(:mem_double) { instance_double(GetProcessMem) }

    before do
      allow(GetProcessMem).to receive(:new).and_return(mem_double)
    end

    context 'when no block is given' do
      before do
        allow(mem_double).to receive(:mb).and_return(100, 100)
      end

      it 'returns hash with nil result and zero memory usage' do
        result = benchmarker.measure
        expect(result).to eq({
          memory_used: 0.0,
          result: nil
        })
      end
    end

    context 'when a block is given' do
      let(:block_result) { 'Test Result' }

      before do
        allow(mem_double).to receive(:mb).and_return(100, 150)
      end

      it 'returns the block result and memory usage' do
        result = benchmarker.measure { block_result }
        expect(result).to eq({
          memory_used: 50.0,
          result: block_result
        })
      end
    end

    context 'when GetProcessMem returns nil' do
      before do
        allow(mem_double).to receive(:mb).and_return(nil, nil)
      end

      it 'handles nil memory values' do
        result = benchmarker.measure { 'test' }
        expect(result).to eq({
          memory_used: 0.0,
          result: 'test'
        })
      end
    end
  end
end
