module ChacathuhuongBenchmarker
  class Base
    attr_reader :label, :options

    def initialize(label, options = {})
      @label = label
      @options = default_options.merge(options)
    end

    def measure
      warmup if ChacathuhuongBenchmarker.configuration.warmup

      results = Benchmark.bmbm do |x|
        x.report(label) { yield if block_given? }
      end

      report_results(results)
    end

    private

    def warmup
      yield if block_given?
    end

    def report_results(results)
      ChacathuhuongBenchmarker.configuration.reporter.report(results)
    end

    def default_options
      {
        iterations: ChacathuhuongBenchmarker.configuration.iterations
      }
    end
  end
end
