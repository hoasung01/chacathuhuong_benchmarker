require 'rails/generators'

module ChacathuhuongBenchmarker
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def create_initializer
      template 'initializer.rb', 'config/initializers/chacathuhuong_benchmarker.rb'
    end

    def create_benchmark_directory
      empty_directory 'benchmarks'
      template 'example_benchmark.rb', 'benchmarks/example_benchmark.rb'
    end
  end
end
