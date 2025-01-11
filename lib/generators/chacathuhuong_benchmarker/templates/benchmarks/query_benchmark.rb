ChacathuhuongBenchmarker::QueryBenchmarker.new("Database Queries").measure_queries(
  {
    label: "Simple find",
    block: -> { User.first }
  },
  {
    label: "Complex query",
    block: -> {
      User.includes(:posts, :comments)
          .where(active: true)
          .order(created_at: :desc)
          .limit(10)
    }
  },
  {
    label: "Raw SQL",
    block: -> {
      ActiveRecord::Base.connection.execute(
        "SELECT * FROM users WHERE active = true LIMIT 10"
      )
    }
  }
)
