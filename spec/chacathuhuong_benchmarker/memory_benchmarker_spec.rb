require 'spec_helper'
require 'chacathuhuong_benchmarker/memory_benchmarker'
require 'get_process_mem'

describe ChacathuhuongBenchmarker::MemoryBenchmarker do
  let(:config) { {} }
  let(:benchmarker) { described_class.new(config) }

  describe '#measure' do
    context 'when no block is given' do
      it 'returns a result of nil' do
        expect(benchmarker.measure[:result]).to be_nil
      end
    end

    context 'when a block is given' do
      let(:block_result) { 'Result from block' }

      it 'returns the result from the block' do
        expect(benchmarker.measure { block_result }[:result]).to eq(block_result)
      end
    end

    context 'when measuring memory usage' do
      let(:memory_before) { 100 }
      let(:memory_after) { 150 }

      it 'returns the correct memory usage' do
        mem = instance_double(GetProcessMem)
        allow(GetProcessMem).to receive(:new).and_return(mem)
        allow(mem).to receive(:mb).and_return(memory_before, memory_after)
        expect(benchmarker.measure[:memory_used]).to eq(50.0)
      end
    end
  end
end
