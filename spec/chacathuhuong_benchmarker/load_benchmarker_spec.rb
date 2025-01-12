require 'spec_helper'
require 'chacathuhuong_benchmarker/load_benchmarker'

RSpec.describe ChacathuhuongBenchmarker::LoadBenchmarker do
  let(:options) do
    {
      concurrent_users: 5,
      duration: 5,  # Reduce duration for faster tests
      endpoints: [
        { path: 'http://localhost:3000/api/users', method: :get },
        { path: 'http://localhost:3000/api/products', method: :post, params: { name: 'Test Product' } }
      ]
    }
  end
  let(:benchmarker) { described_class.new(options) }
  let(:mock_response) { double(code: '200', is_a?: true) } # Mock response for make_request

  before do
    # Mock logger first
    allow(benchmarker).to receive(:logger).and_return(double(error: nil))
    # Mock make_request, this can be overridden in specific test cases
    allow(benchmarker).to receive(:make_request).and_return(mock_response)
  end

  describe '#measure_endpoint' do
    it 'measures the performance of a single endpoint' do
      result = benchmarker.measure_endpoint(options[:endpoints][0][:path])

      expect(result).to be_a(Hash)
      expect(result).to include(:endpoint, :total_requests, :errors, :requests_per_second, :response_time)
      expect(result[:response_time]).to include(:min, :max, :avg, :median, :p95, :p99)
    end

    it 'handles errors during requests' do
      # Override mock make_request for this test case
      allow(benchmarker).to receive(:make_request).and_raise(StandardError.new("Request failed"))

      result = benchmarker.measure_endpoint(options[:endpoints][0][:path])

      expect(result).to be_a(Hash)
      expect(result[:errors]).to be > 0
    end
  end

  describe '#measure_multiple_endpoints' do
    it 'measures the performance of multiple endpoints' do
      result = benchmarker.measure_multiple_endpoints

      expect(result).to be_a(Hash)
      expect(result).to include(:summary, :results)
      expect(result[:results].size).to eq(options[:endpoints].size)
    end
  end

  describe '#calculate_statistics' do
    it 'calculates the correct statistics' do
      start_time = Time.now - 5 # Fixed start time for consistent calculation
      response_times = [0.1, 0.2, 0.3, 0.4, 0.5]
      results = {
        response_times: response_times,
        start_time: start_time,
        requests: 5,
        errors: 0,
        endpoint: options[:endpoints][0][:path]
      }
      stats = benchmarker.send(:calculate_statistics, results)

      expect(stats[:total_requests]).to eq(5)
      expect(stats[:errors]).to eq(0)
      # Calculate requests_per_second based on the fixed start_time
      expect(stats[:requests_per_second]).to eq((results[:requests] / (Time.now - start_time)).round(2))
      expect(stats[:response_time][:min]).to eq(0.1)
      expect(stats[:response_time][:max]).to eq(0.5)
      expect(stats[:response_time][:avg]).to eq(0.3)
      expect(stats[:response_time][:median]).to eq(0.3)
      expect(stats[:response_time][:p95]).to eq(benchmarker.send(:percentile, response_times, 95))
      expect(stats[:response_time][:p99]).to eq(benchmarker.send(:percentile, response_times, 99))
    end

    it 'handles empty response_times array' do
      results = {
        response_times: [],
        start_time: Time.now - 5,
        requests: 5,
        errors: 5,
        endpoint: options[:endpoints][0][:path]
      }
      stats = benchmarker.send(:calculate_statistics, results)

      expect(stats[:response_time][:min]).to eq(0)
      expect(stats[:response_time][:max]).to eq(0)
      expect(stats[:response_time][:avg]).to eq(0)
    end
  end

  describe '#generate_report' do
    it 'generates the correct report format' do
      report = benchmarker.send(:generate_report)

      expect(report).to be_a(Hash)
      expect(report[:summary]).to include(:total_duration, :concurrent_users, :total_endpoints, :timestamp)
      expect(report[:results]).to be_an(Array)
    end
  end

  describe '#make_request' do
    it 'makes a GET request with parameters' do
      uri = URI('http://localhost:3000/api/users?param1=value1&param2=value2')

      # Use `allow(Net::HTTP).to receive(:start)` and `expect(http).to receive(:request)`
      allow(Net::HTTP).to receive(:start).with(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |&block|
        http = double(Net::HTTP)
        expect(http).to receive(:request).and_return(mock_response)
        block.call(http) # Execute the block with the mock http
      end

      benchmarker.send(:make_request, uri.to_s, :get, { param1: 'value1', param2: 'value2' })
    end

    it 'makes a POST request with parameters' do
      uri = URI('http://localhost:3000/api/products')

      # Use `allow(Net::HTTP).to receive(:start)` and `expect(http).to receive(:request)`
      allow(Net::HTTP).to receive(:start).with(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |&block|
        http = double(Net::HTTP)
        expect(http).to receive(:request).and_return(mock_response)
        block.call(http) # Execute the block with the mock http
      end

      benchmarker.send(:make_request, uri.to_s, :post, { name: 'Test Product' })
    end

    it 'raises an error if the request is not successful' do
      # TODO
    end
  end

  describe '#calculate_median' do
    it 'calculates the median of an odd-length array' do
      expect(benchmarker.send(:calculate_median, [1, 2, 3])).to eq(2)
    end

    it 'calculates the median of an even-length array' do
      expect(benchmarker.send(:calculate_median, [1, 2, 3, 4])).to eq(2.5)
    end
  end

  describe '#percentile' do
    let(:sorted_array) { [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] }

    it 'calculates the correct percentile' do
      expect(benchmarker.send(:percentile, sorted_array, 50)).to eq(5.5)
      expect(benchmarker.send(:percentile, sorted_array, 90)).to eq(9.1)
      expect(benchmarker.send(:percentile, sorted_array, 95)).to eq(9.55)
    end

    it 'returns 0 for an empty array' do
      expect(benchmarker.send(:percentile, [], 90)).to eq(0)
    end
  end

  describe '#synchronized' do
    it 'executes the block with a mutex' do
      mutex = double(Mutex)
      expect(Mutex).to receive(:new).and_return(mutex)
      expect(mutex).to receive(:synchronize)

      benchmarker.send(:synchronized) {}
    end
  end
end
