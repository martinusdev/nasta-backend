require 'nasta/github/test_count_report'

RSpec.describe Github::TestCountReport do

  let(:repository) do
    double()
  end

  subject do
    Github::TestCountReport.new(repository)
  end

  describe 'run_ids' do
    it 'should fetch runs from repository' do
      expect(repository).to receive(:runs) do
        {:total_count=>1, :workflow_runs=>[{:id=>1234}]}
      end
      subject.run_ids
    end

    it 'should parse run ids from response' do
      allow(repository).to receive(:runs) do
        {:total_count=>2, :workflow_runs=>[{:id=>1234}, {:id=>5678}]}
      end
      expect(subject.run_ids).to eq([1234, 5678])
    end

    it 'should return maximum of 10 run ids' do
      allow(repository).to receive(:runs) do
        {:total_count=>20, :workflow_runs=> (1..20).map { |id| {id: id} }}
      end
      expect(subject.run_ids).to eq([1,2,3,4,5,6,7,8,9,10])
    end

    context 'with malformed response' do
      it 'should raise error if not Hash' do
        allow(repository).to receive(:runs) { nil }
        expect { subject.run_ids }.to raise_error(/malformed response/)
      end
      it 'should raise error if invalid structure' do
        allow(repository).to receive(:runs) { {key: 'value'} }
        expect { subject.run_ids }.to raise_error(/malformed response/)
      end
    end
  end

  describe 'artifacts' do
    it 'should fetch artifacts from repository' do
      expect(repository).to receive(:artifacts).with(55) do
        {:total_count=>1, :artifacts=>[{:id=>1234}]}
      end
      subject.artifacts(55)
    end

    it 'should return artifacts from response' do
      allow(repository).to receive(:artifacts) do
        {:total_count=>2, :artifacts=>[{:id=>12, :name=>'A12'}, {:id=>15, :name=>'A15'}]}
      end
      expect(subject.artifacts(1)).to eq([{:id=>12, :name=>'A12'}, {:id=>15, :name=>'A15'}])
    end

    context 'with malformed response' do
      it 'should raise error if not Hash' do
        allow(repository).to receive(:runs) { nil }
        expect { subject.run_ids }.to raise_error(/malformed response/)
      end
      it 'should raise error if invalid structure' do
        allow(repository).to receive(:runs) { {key: 'value'} }
        expect { subject.run_ids }.to raise_error(/malformed response/)
      end
    end
  end

  describe 'contain_test_results?' do
    it 'should return true if both artifacts present' do
      artifacts = [{:name => 'Martinus PHPUnit'}, {:name => 'Nimda PHPUnit'}]
      expect(subject.contain_test_results?(artifacts)).to eq(true)
    end

    it 'should return false if artifacts empty' do
      artifacts = []
      expect(subject.contain_test_results?(artifacts)).to eq(false)
    end

    it 'should return false if artifacts do not contain both test results' do
      artifacts = [{:name => 'Martinus PHPUnit'}, {:name => 'Nimda JS'}]
      expect(subject.contain_test_results?(artifacts)).to eq(false)
    end
  end

  describe 'find_artifacts' do
    let(:runs) do
      {:total_count=>20, :workflow_runs=> (1..5).map {|id| {id: id}}}
    end

    let(:invalid_artifacts) do
      {:total_count=>2, :artifacts=>[{:id=>1, :name=>'Martinus JS'}, {:id=>2, :name=>'Nimda JS'}]}
    end

    let(:valid_artifacts) do
      {:total_count=>2, :artifacts=>[{:id=>3, :name=>'Martinus PHPUnit'}, {:id=>4, :name=>'Nimda PHPUnit'}, {:id=>5, :name=>'Nimda JS'}]}
    end

    it 'should lazily fetch artifacts' do
      expect(repository).to receive(:runs).and_return(runs)
      expect(repository).to receive(:artifacts).twice.and_return(invalid_artifacts, valid_artifacts)

      subject.find_artifacts
    end

    it 'should return atrifacts with test results' do
      allow(repository).to receive(:runs).and_return(runs)
      allow(repository).to receive(:artifacts).and_return(invalid_artifacts, valid_artifacts)

      expect(subject.find_artifacts).to eq([
        {:id=>3, :name=>'Martinus PHPUnit'}, 
        {:id=>4, :name=>'Nimda PHPUnit'}
      ])
    end

    it 'should raise error if no valid artifacts found' do
      allow(repository).to receive(:runs).and_return(runs)
      allow(repository).to receive(:artifacts).and_return(invalid_artifacts)

      expect { subject.find_artifacts }.to raise_error(/Did not find any artifacts with test results/)
    end
  end

  describe 'unzip' do
    let(:archive) {
      File.read(__dir__ + '/valid.zip')
    }

    let(:invalid_archive) {
      File.read(__dir__ + '/invalid.zip')
    }

    let(:invalid_file) {
      File.read(__dir__ + '/invalid.txt')
    }

    it 'should raise error for invalid file' do
      expect {
        subject.unzip(invalid_file)
      }.to raise_error(/does not contain any file/)
    end

    it 'should raise error for invalid archive' do
      expect {
        subject.unzip(invalid_archive)
      }.to raise_error(/expected contain only 1 file named testsuites.xml/)
    end

    it 'should return contents of testsuites.xml' do
      expect(subject.unzip(archive)).to eq(File.read(__dir__ + '/testsuites.xml'))
    end
  end

  describe 'parse_test_count' do
    let(:valid_xml) do
      File.read(__dir__ + '/testsuites.xml')
    end

    let(:invalid_xml) do 
      '<tag>'
    end

    let(:not_xml) do
      'string'
    end

    let(:empty_xml) do
      ''
    end

    let(:invalid_junit) do
      '<testsuites><test></test></testsuites>'
    end

    let(:invalid_count) do
      '<testsuites><testsuite tests="asd"></testsuite></testsuites>'
    end

    it 'should raise error for invalid xml' do
      expect { subject.parse_test_count(invalid_xml) }.to raise_error(/No close tag/)
    end

    it 'should raise error for not an xml' do
      expect { subject.parse_test_count(not_xml) }.to raise_error(/does not have a valid root/)
    end

    it 'should raise error for invalid xml' do
      expect { subject.parse_test_count(empty_xml) }.to raise_error(/Failed to parse XML ``/)
    end

    it 'should raise error for invalid jUnit XML' do
      expect { subject.parse_test_count(invalid_junit) }.to raise_error(/not valid jUnit XML/)
    end

    it 'should raise error for invalid test count' do
      expect { subject.parse_test_count(invalid_count) }.to raise_error(/invalid value for Integer\(\): "asd"/)
    end

    it 'should parse number of tests' do
      expect(subject.parse_test_count(valid_xml)).to eq(1273)
    end
  end

  describe 'fetch' do
    let(:runs) do
      {:total_count=>20, :workflow_runs=> (1..5).map {|id| {id: id}}}
    end

    let(:artifacts) do
      {:total_count=>2, :artifacts=>[{:id=>3, :name=>'Martinus PHPUnit'}, {:id=>4, :name=>'Nimda PHPUnit'}]}
    end

    let(:artifact_archive) do
      File.read(__dir__ + '/valid.zip')
    end

    it 'everything should work together' do
      allow(repository).to receive(:runs).and_return(runs)
      allow(repository).to receive(:artifacts).and_return(artifacts)
      allow(repository).to receive(:artifact_archive).and_return(artifact_archive)

      timestamp = Time.now.in_time_zone('Europe/Bratislava').noon.to_i

      expect(subject.fetch).to eq([
        ['tests_martinus_phpunit', timestamp, 1273], 
        ['tests_nimda_phpunit', timestamp, 1273]
      ])
    end
  end

end