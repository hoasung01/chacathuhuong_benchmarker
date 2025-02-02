require 'benchmark'

module ChacathuhuongBenchmarker
  class QueryBenchmarker < Base
    def measure_queries(*queries)
      results = Benchmark.bmbm do |x|
        queries.each do |query|
          x.report(query[:label]) { query[:block].call }
        end
      end

      report_results(results)
    end

    private

    def report_results(results)
      {
        timestamp: Time.now,
        queries: results.map { |r| { label: r.label, real: r.real, utime: r.utime, stime: r.stime } }
      }
    end
  end
end
