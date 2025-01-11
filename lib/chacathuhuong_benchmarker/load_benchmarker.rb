require 'net/http'
require 'concurrent'
require 'benchmark'

module ChacathuhuongBenchmarker
  class LoadBenchmarker < Base
    attr_reader :concurrent_users, :duration, :endpoints

    def initialize(options = {})
      @concurrent_users = options.fetch(:concurrent_users, 10)
      @duration = options.fetch(:duration, 60) # seconds
      @endpoints = options.fetch(:endpoints, [])
      @results = []
      super('Load Test', options)
    end

    def measure_endpoint(endpoint, method: :get, params: {})
      results = {
        endpoint: endpoint,
        method: method,
        requests: 0,
        errors: 0,
        response_times: [],
        start_time: Time.now
      }

      pool = Concurrent::FixedThreadPool.new(concurrent_users)
      end_time = Time.now + duration

      while Time.now < end_time
        pool.post do
          begin
            response_time = Benchmark.realtime do
              make_request(endpoint, method, params)
            end

            synchronized do
              results[:requests] += 1
              results[:response_times] << response_time
            end
          rescue => e
            synchronized do
              results[:errors] += 1
              logger.error("Request failed: #{e.message}")
            end
          end
        end
      end

      pool.shutdown
      pool.wait_for_termination

      calculate_statistics(results)
    end

    def measure_multiple_endpoints
      endpoints.each do |endpoint_config|
        result = measure_endpoint(
          endpoint_config[:path],
          method: endpoint_config[:method] || :get,
          params: endpoint_config[:params] || {}
        )
        @results << result
      end

      generate_report
    end

    private

    def make_request(endpoint, method, params)
      uri = URI(endpoint)
      case method.to_sym
      when :get
        uri.query = URI.encode_www_form(params)
        request = Net::HTTP::Get.new(uri)
      when :post
        request = Net::HTTP::Post.new(uri)
        request.set_form_data(params)
      end

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(request)
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise "Request failed with status: #{response.code}"
      end

      response
    end

    def calculate_statistics(results)
      return if results[:response_times].empty?

      response_times = results[:response_times].sort
      total_time = Time.now - results[:start_time]

      {
        endpoint: results[:endpoint],
        total_requests: results[:requests],
        errors: results[:errors],
        requests_per_second: (results[:requests] / total_time).round(2),
        response_time: {
          min: response_times.first.round(3),
          max: response_times.last.round(3),
          avg: (response_times.sum / response_times.size).round(3),
          median: calculate_median(response_times),
          p95: percentile(response_times, 95),
          p99: percentile(response_times, 99)
        }
      }
    end

    def calculate_median(sorted_array)
      mid = sorted_array.length / 2
      if sorted_array.length.even?
        ((sorted_array[mid-1] + sorted_array[mid]) / 2.0).round(3)
      else
        sorted_array[mid].round(3)
      end
    end

    def percentile(sorted_array, percentile)
      return 0 if sorted_array.empty?

      k = (percentile / 100.0) * (sorted_array.length - 1)
      f = k.floor
      c = k.ceil

      if f == c
        sorted_array[f].round(3)
      else
        (sorted_array[f] * (c - k) + sorted_array[c] * (k - f)).round(3)
      end
    end

    def generate_report
      {
        summary: {
          total_duration: duration,
          concurrent_users: concurrent_users,
          total_endpoints: endpoints.size,
          timestamp: Time.now
        },
        results: @results
      }
    end

    def logger
      @logger ||= Logger.new("#{ChacathuhuongBenchmarker.configuration.output_path}/load_test.log")
    end

    def synchronized
      @mutex ||= Mutex.new
      @mutex.synchronize { yield }
    end
  end
end
