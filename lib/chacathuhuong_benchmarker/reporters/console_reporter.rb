module ChacathuhuongBenchmarker
  module Reporters
    class ConsoleReporter < BaseReporter
      def report(results)
        puts "\n=== Benchmark Results ==="
        puts results
      end
    end
  end
end
