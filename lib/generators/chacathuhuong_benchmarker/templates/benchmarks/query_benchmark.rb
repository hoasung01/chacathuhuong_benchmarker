# frozen_string_literal: true

require 'chacathuhuong_benchmarker'
require 'chacathuhuong_benchmarker/query_benchmarker'

query_test = ChacathuhuongBenchmarker::QueryBenchmarker.new("Database Queries")

begin
  results = query_test.measure_queries(
    {
      label: "Simple Array Operation",
      block: -> { (1..1000).to_a.shuffle.sort }
    },
    {
      label: "String Manipulation",
      block: -> { "hello world" * 1000 }
    }
  )

  puts "Query Benchmark Results:"
  puts results.inspect
rescue StandardError => e
  puts "Error during query benchmark: #{e.message}"
  puts e.backtrace
end
