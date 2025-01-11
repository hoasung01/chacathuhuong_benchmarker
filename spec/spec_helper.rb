require 'chacathuhuong_benchmarker'
require 'chacathuhuong_benchmarker/reporters/base_reporter'
require 'chacathuhuong_benchmarker/reporters/json_reporter'
require 'chacathuhuong_benchmarker/reporters/console_reporter'
require 'rspec'
require 'timecop'
require 'webmock'
require 'factory_bot'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    FactoryBot.find_definitions

    ChacathuhuongBenchmarker.configure do |config|
      config.iterations = 10
      config.output_path = 'tmp/benchmark_results'
      config.reporter = ChacathuhuongBenchmarker::Reporters::ConsoleReporter.new
    end
  end
end
