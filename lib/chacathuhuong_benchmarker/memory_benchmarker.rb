module ChacathuhuongBenchmarker
  class MemoryBenchmarker < Base
    def measure
      memory_before = GetProcessMem.new.mb
      result = yield if block_given?
      memory_after = GetProcessMem.new.mb

      {
        memory_used: memory_after - memory_before,
        result: result
      }
    end
  end
end
