# frozen_string_literal: true

require 'chacathuhuong_benchmarker'
require 'chacathuhuong_benchmarker/load_benchmarker'

load_test = ChacathuhuongBenchmarker::LoadBenchmarker.new(
  concurrent_users: 2, # Start with a lower number for testing
  duration: 5, # Shorter duration for initial testing
  endpoints: [
    {
      path: 'http://localhost:3000/health_check', # Simple health check endpoint
      method: :get
    },
    {
      path: 'http://localhost:3000/api/status', # Status endpoint
      method: :get
    }
  ]
)

begin
  results = load_test.measure_multiple_endpoints
  puts "Load test completed successfully"
  puts "Results: #{results.inspect}"
rescue StandardError => e
  puts "Error during load test: #{e.message}"
  puts e.backtrace
end
