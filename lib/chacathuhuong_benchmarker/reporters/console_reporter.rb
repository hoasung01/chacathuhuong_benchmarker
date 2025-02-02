module ChacathuhuongBenchmarker
  module Reporters
    class ConsoleReporter < BaseReporter
      def report(results)
        puts "\n=== Benchmark Results ==="
        puts results
        puts "=== End of Results ===\n"
      end
    end
  end
end
