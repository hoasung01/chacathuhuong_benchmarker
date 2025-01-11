module ChacathuhuongBenchmarker
  module Reporters
    class BaseReporter
      def report(results)
        raise NotImplementedError
      end
    end
  end
end
