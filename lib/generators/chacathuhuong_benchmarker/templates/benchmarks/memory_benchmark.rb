# frozen_string_literal: true

require 'chacathuhuong_benchmarker'
require 'chacathuhuong_benchmarker/memory_benchmarker'

memory_test = ChacathuhuongBenchmarker::MemoryBenchmarker.new(
  "Memory Allocation Test",
  { gc_stats: true }
)

result = memory_test.measure do
  array = []
  10_000.times do |i|
    array << "test string #{i}"
  end
end

puts "Memory Test Results:"
puts result.inspect
