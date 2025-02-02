# frozen_string_literal: true

require 'chacathuhuong_benchmarker'

ChacathuhuongBenchmarker.run("Example Benchmark") do
  # Example of CPU-intensive operation
  array = (1..10_000).to_a
  array.shuffle.sort
end

# Custom configuration for this benchmark
ChacathuhuongBenchmarker.configure do |config|
  config.iterations = 3
  config.reporter = ChacathuhuongBenchmarker::Reporters::JsonReporter.new
end
