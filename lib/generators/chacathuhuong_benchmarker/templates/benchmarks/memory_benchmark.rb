ChacathuhuongBenchmarker::MemoryBenchmarker.new(
  label: "Memory Usage",
  options: { gc_stats: true }
).measure do
  1000.times do
    User.new(name: "Test", email: "test@example.com")
  end
end
