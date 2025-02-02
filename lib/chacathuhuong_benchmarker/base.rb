module ChacathuhuongBenchmarker
  class Base
    attr_reader :label, :options

    def initialize(label, options = {})
      @label = label
      @options = default_options.merge(options)
    end

    def measure(iterations = @options[:iterations])
      return unless block_given?

      warmup { yield } if ChacathuhuongBenchmarker.configuration.warmup

      results = Benchmark.bmbm do |x|
        iterations.times do
          x.report(label) { yield }
        end
      end

      report_results(results)
      results
    end

    private

    def warmup
      GC.start # Clear garbage before warmup
      yield if block_given?
    end

    def report_results(results)
      ChacathuhuongBenchmarker.configuration.reporter&.report(results)
    end

    def default_options
      {
        iterations: ChacathuhuongBenchmarker.configuration&.iterations || 1
      }
    end
  end
end
