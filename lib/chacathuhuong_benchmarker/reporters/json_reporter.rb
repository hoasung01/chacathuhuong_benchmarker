module ChacathuhuongBenchmarker
  module Reporters
    class JsonReporter < BaseReporter
      def report(results)
        File.write(
          "#{ChacathuhuongBenchmarker.configuration.output_path}/#{Time.now.to_i}.json",
          results.to_json
        )
      end
    end
  end
end
