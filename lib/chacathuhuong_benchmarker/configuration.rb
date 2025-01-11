module ChacathuhuongBenchmarker
  class Configuration
    attr_accessor :iterations, :warmup, :reporter, :output_path

    def initialize
      @iterations = 1
      @warmup = true
      @reporter = Reporters::ConsoleReporter.new
      @output_path = 'log/benchmarks'
    end
  end
end
