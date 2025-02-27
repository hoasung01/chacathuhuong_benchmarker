# frozen_string_literal: true

require_relative "lib/chacathuhuong_benchmarker/version"

Gem::Specification.new do |spec|
  spec.name = "chacathuhuong_benchmarker"
  spec.version = ChacathuhuongBenchmarker::VERSION
  spec.authors = ["hoasung01"]
  spec.email = ["nguyenngochai.shipagent@gmail.com"]

  spec.summary = "A simple and flexible benchmarking library for Ruby"
  spec.description = "ChacathuhuongBenchmarker provides a convenient way to benchmark your Ruby code and track performance over time."
  spec.homepage = "https://github.com/hoasung01/chacathuhuong_benchmarker"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rails", "~> 7.0"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "timecop", "~> 0.9.6"
  spec.add_development_dependency "webmock", "~> 3.18"
  spec.add_development_dependency "factory_bot", "~> 6.2"
  spec.add_dependency "get_process_mem", "~> 0.2.1"
end
