require 'octokit'
require 'zip'
require 'active_support/all'
require 'active_support/core_ext'
require 'nasta/github/repository'

module Github
  class TestCountReport
    ARTIFACT_NAMES = [
      'Martinus PHPUnit', 
      'Nimda PHPUnit'
    ]

    def initialize(repository = nil)
      @repository = repository || Github::Repository.new(ENV['GITHUB_TESTS_REPOSITORY'])
    end

    def fetch
      noon_timestamp = Time.now.in_time_zone('Europe/Bratislava').noon.to_i

      find_artifacts.map do |artifact|
        archive = @repository.artifact_archive(artifact[:id])
        xml = unzip(archive)
        test_count = parse_test_count(xml)

        [report_name(artifact), noon_timestamp, test_count]
      end
    end

    def report_name(artifact)
      "tests_" + artifact[:name].parameterize.underscore
    end

    def find_artifacts
      artifacts = run_ids.lazy
        .map { |run_id| artifacts(run_id) }
        .find { |artifacts| contain_test_results?(artifacts) }

      raise "Did not find any artifacts with test results" if artifacts.nil?

      artifacts.select { |a| ARTIFACT_NAMES.include?(a[:name]) }
    end

    def run_ids
      response = @repository.runs
      assert_github_response(response, :workflow_runs)

      response[:workflow_runs].first(10).map do |run|
        run[:id]
      end
    end

    def artifacts(run_id)
      response = @repository.artifacts(run_id)
      assert_github_response(response, :artifacts)

      response[:artifacts]
    end

    def contain_test_results?(artifacts)
      contains = ARTIFACT_NAMES.map do |artifact_name|
        artifacts.any? { |a| a[:name] == artifact_name }
      end

      contains.all?
    end

    def unzip(archive)
      xml = nil

      Zip::File.open_buffer(StringIO.new(archive)) do |zip_file|
        entry = zip_file.first
        raise "Artifact archive does not contain any files" if entry.nil?
        raise "Artifact archive expected contain only 1 file named testsuites.xml, file #{entry.name} found" if entry.name != "testsuites.xml"
        xml = entry.get_input_stream.read
      end

      xml
    end

    def parse_test_count(xml)
      parsed = Hash.from_xml(xml)
      raise "Failed to parse XML `#{xml}`" unless parsed.is_a? Hash

      tests_string = parsed.dig 'testsuites', 'testsuite', 'tests'
      raise "XML is not valid jUnit XML" if tests_string.nil?

      Integer(tests_string)
    end

    private

    def assert_github_response(response, expected_key)
      unless response.key?(expected_key)
        raise "Github API returned malformed response: #{response.inspect[0..200]}"
      end
    end
  end
end