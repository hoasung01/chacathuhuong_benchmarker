# frozen_string_literal: true

ChacathuhuongBenchmarker::QueryBenchmarker.new("Database Queries").measure_queries(
  {
    label: "Simple find",
    block: -> { User.first }
  },
  {
    label: "Complex query",
    block: lambda do
      User.includes(:posts, :comments)
          .where(active: true)
          .order(created_at: :desc)
          .limit(10)
    end
  },
  {
    label: "Raw SQL",
    block: lambda do
      ActiveRecord::Base.connection.execute(
        "SELECT * FROM users WHERE active = true LIMIT 10"
      )
    end
  }
)
