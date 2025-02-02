module ChacathuhuongBenchmarker
  module Reporters
    class JsonReporter < BaseReporter
      def report(results)
        return if results.nil? || results.empty?

        FileUtils.mkdir_p(output_dir)
        File.write(output_file_path, results.to_json)
      end

      private

      def output_dir
        ChacathuhuongBenchmarker.configuration.output_path
      end

      def output_file_path
        "#{output_dir}/benchmark_#{Time.now.to_i}.json"
      end
    end
  end
end
