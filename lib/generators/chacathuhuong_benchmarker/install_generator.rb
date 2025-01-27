require 'rails/generators'

module ChacathuhuongBenchmarker
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def create_initializer
      template 'config/initializer.rb', 'config/initializers/chacathuhuong_benchmarker.rb'
    end

    def create_benchmark_directory
      empty_directory 'benchmarks'
      template 'benchmarks/example_benchmark.rb', 'benchmarks/example_benchmark.rb'
      template 'benchmarks/load_benchmark.rb', 'benchmarks/load_benchmark.rb'
      template 'benchmarks/memory_benchmark.rb', 'benchmarks/memory_benchmark.rb'
      template 'benchmarks/query_benchmark.rb', 'benchmarks/query_benchmark.rb'
    end
  end
end
