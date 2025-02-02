require 'get_process_mem'

module ChacathuhuongBenchmarker
  class MemoryBenchmarker < Base
    def initialize(label, options = {})
      super(label, options)
    end

    def measure(&block)
      mem = GetProcessMem.new
      memory_before = mem.mb || 0
      result = block_given? ? yield : nil
      memory_after = mem.mb || 0
      {
        memory_used: (memory_after - memory_before).round(2),
        result: result
      }
    end
  end
end
