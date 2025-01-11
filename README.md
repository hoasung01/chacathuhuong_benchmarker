# ChacathuhuongBenchmarker

A focused benchmarking toolkit for Ruby on Rails applications that provides insights into:
- Load Testing
- Memory Usage Analysis
- Query Performance Optimization

## Installation

```ruby
# Add to your Gemfile
gem 'chacathuhuong_benchmarker'
```

```bash
# Install via terminal
bundle install
rails generate chacathuhuong_benchmarker:install
```

## Core Features

### 1. Load Benchmarker
```ruby
# Simple load test
load_test = ChacathuhuongBenchmarker::LoadBenchmarker.new(
  concurrent_users: 10,
  duration: 60
)

# Test single endpoint
load_test.test_endpoint('https://api.example.com/users')

# Test multiple endpoints
load_test.test_endpoints([
  {
    path: 'https://api.example.com/users',
    method: :get
  },
  {
    path: 'https://api.example.com/posts',
    method: :post,
    params: { title: 'Test Post' }
  }
])
```

### 2. Memory Benchmarker
```ruby
# Simple memory analysis
memory_test = ChacathuhuongBenchmarker::MemoryBenchmarker.new

memory_test.measure do
  1000.times { User.new(name: 'Test User') }
end

# Detailed memory analysis with garbage collection
memory_test.measure(gc_stats: true) do
  User.all.map(&:calculate_complex_stats)
end
```

### 3. Query Benchmarker
```ruby
# Compare query performance
query_test = ChacathuhuongBenchmarker::QueryBenchmarker.new

query_test.compare([
  {
    label: "Simple Find",
    query: -> { User.first }
  },
  {
    label: "Complex Query",
    query: -> { User.includes(:posts).where(active: true) }
  }
])
```

## Configuration

```ruby
# config/initializers/chacathuhuong_benchmarker.rb
ChacathuhuongBenchmarker.configure do |config|
  # Load testing configuration
  config.load_test = {
    concurrent_users: 10,
    duration: 60,
    timeout: 30
  }

  # Memory testing configuration
  config.memory_test = {
    gc_stats: true,
    detailed_report: true
  }

  # Query testing configuration
  config.query_test = {
    iterations: 5,
    warmup_runs: 2
  }
end
```

## Sample Outputs

### Load Test Report
```ruby
{
  endpoint: "https://api.example.com/users",
  statistics: {
    total_requests: 1000,
    successful_requests: 985,
    failed_requests: 15,
    average_response_time: 0.234,
    requests_per_second: 45.5
  }
}
```

### Memory Analysis Report
```ruby
{
  initial_memory: 100_000,
  final_memory: 150_000,
  memory_increase: 50_000,
  gc_stats: {
    count: 3,
    heap_allocated_pages: 125,
    heap_sorted_length: 126
  }
}
```

### Query Performance Report
```ruby
{
  comparisons: [
    {
      label: "Simple Find",
      average_time: 0.001,
      total_queries: 1
    },
    {
      label: "Complex Query",
      average_time: 0.015,
      total_queries: 3
    }
  ]
}
```

## Best Practices

### Load Testing
- Start with low concurrent users
- Increase load gradually
- Monitor system resources
- Test various endpoints
- Set appropriate timeouts

### Memory Analysis
- Clear garbage collection before tests
- Monitor memory growth patterns
- Check for memory leaks
- Use representative data sizes

### Query Testing
- Test with realistic data volumes
- Include warm-up runs
- Compare similar queries
- Test in isolation

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -am 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

Released under the [MIT License](https://opensource.org/licenses/MIT).
