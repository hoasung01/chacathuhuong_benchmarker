module ChacathuhuongBenchmarker
  class Configuration
    attr_accessor :iterations, :warmup, :reporter, :output_path,
                  :load_test, :memory_test

    def initialize
      @iterations = 1
      @warmup = true
      @reporter = Reporters::ConsoleReporter.new
      @output_path = 'log/benchmarks'
      @load_test = {
        concurrent_users: 10,
        duration: 60,
        timeout: 30
      }
      @memory_test = {
        detailed: true,
        gc_stats: true
      }
    end
  end
end
