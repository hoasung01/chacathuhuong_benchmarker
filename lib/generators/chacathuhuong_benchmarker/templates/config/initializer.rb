# frozen_string_literal: true

ChacathuhuongBenchmarker.configure do |config|
  config.iterations = 5
  config.warmup = true
  config.output_path = Rails.root.join('log/benchmarks')

  # Reporter configuration
  config.reporter = ChacathuhuongBenchmarker::Reporters::ConsoleReporter.new

  # Load test configuration
  config.load_test = {
    concurrent_users: 10,
    duration: 60,
    timeout: 30
  }

  # Memory test configuration
  config.memory_test = {
    detailed: true,
    gc_stats: true
  }
end
