require 'spec_helper'
require 'rails/generators'
require 'generators/chacathuhuong_benchmarker/install_generator'
require 'fileutils'

module ChacathuhuongBenchmarker
  RSpec.describe InstallGenerator do
    let(:destination_root) { File.expand_path('../../tmp', __dir__) }

    before do
      FileUtils.mkdir_p(destination_root)
    end

    after do
      FileUtils.rm_rf(destination_root)
    end

    def run_generator_instance
      generator = described_class.new
      generator.destination_root = destination_root
      generator.invoke_all
    end

    it "creates initializer file" do
      run_generator_instance
      expect(File.exist?("#{destination_root}/config/initializers/chacathuhuong_benchmarker.rb")).to be true
    end

    it "creates benchmarks directory" do
      run_generator_instance
      expect(File.directory?("#{destination_root}/benchmarks")).to be true
    end

    describe "benchmark files" do
      before { run_generator_instance }

      %w[
        example_benchmark.rb
        load_benchmark.rb
        memory_benchmark.rb
        query_benchmark.rb
      ].each do |file|
        it "creates #{file}" do
          expect(File.exist?("#{destination_root}/benchmarks/#{file}")).to be true
        end
      end
    end

    describe "file contents" do
      before { run_generator_instance }

      it "creates initializer with configuration block" do
        content = File.read("#{destination_root}/config/initializers/chacathuhuong_benchmarker.rb")
        expect(content).to match(/ChacathuhuongBenchmarker\.configure do \|config\|/)
      end

      {
        'load_benchmark.rb' => 'LoadBenchmarker',
        'memory_benchmark.rb' => 'MemoryBenchmarker',
        'query_benchmark.rb' => 'QueryBenchmarker'
      }.each do |file, class_name|
        it "creates #{file} with proper class reference" do
          content = File.read("#{destination_root}/benchmarks/#{file}")
          expect(content).to match(/ChacathuhuongBenchmarker::#{class_name}/)
        end
      end
    end
  end
end
