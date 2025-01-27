# frozen_string_literal: true

require 'chacathuhuong_benchmarker'

ChacathuhuongBenchmarker.run("Example Benchmark") do
  # Your code here
  User.all.to_a
end

# Custom configuration for this benchmark
ChacathuhuongBenchmarker.configure do |config|
  config.iterations = 3
  config.reporter = ChacathuhuongBenchmarker::Reporters::JsonReporter.new
end
