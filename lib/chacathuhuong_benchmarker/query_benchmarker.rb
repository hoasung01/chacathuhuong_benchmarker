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
  end
end
