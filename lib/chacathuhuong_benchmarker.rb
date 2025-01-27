require 'benchmark'
require 'chacathuhuong_benchmarker/version'
require 'chacathuhuong_benchmarker/configuration'
require 'chacathuhuong_benchmarker/base'
require 'chacathuhuong_benchmarker/reporters/base_reporter'
require 'chacathuhuong_benchmarker/reporters/console_reporter'
require 'chacathuhuong_benchmarker/reporters/json_reporter'

module ChacathuhuongBenchmarker
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end

    def run(label, options = {}, &block)
      Base.new(label, options).measure(&block)
    end
  end
end
