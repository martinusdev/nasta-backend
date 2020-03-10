require 'lambda_handler'

RSpec.describe 'lambda_handler' do
  it 'should return error if report name not given' do
    result = lambda_handler event: {}, context: nil

    expect(result).to have_key(:statusCode)
    expect(result).to have_key(:body)
    expect(result[:statusCode]).to eq(400)
  end

  it 'should return error if report does not exist' do
    result = lambda_handler event: {'report' => 'Dummy::NotExistingReport'}, context: nil

    expect(result).to have_key(:statusCode)
    expect(result).to have_key(:body)
    expect(result[:statusCode]).to eq(404)
  end

  it 'should return error if report raises exception' do
    result = lambda_handler event: {'report' => 'Dummy::ErrorReport'}, context: nil

    expect(result).to have_key(:statusCode)
    expect(result).to have_key(:body)
    expect(result[:statusCode]).to eq(500)
  end

  it 'should return success if report finished correctly' do
    result = lambda_handler event: {'report' => 'Dummy::SuccessReport'}, context: nil

    expect(result).to have_key(:statusCode)
    expect(result).to have_key(:body)
    expect(result[:statusCode]).to eq(200)
  end
end