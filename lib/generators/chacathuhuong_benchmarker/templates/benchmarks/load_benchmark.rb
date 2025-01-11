ChacathuhuongBenchmarker::LoadBenchmarker.new(
  concurrent_users: 20,
  duration: 300,
  endpoints: [
    {
      path: 'http://localhost:3000/api/v1/users',
      method: :get
    },
    {
      path: 'http://localhost:3000/api/v1/posts',
      method: :post,
      params: { title: 'Test' }
    }
  ]
).measure_multiple_endpoints
