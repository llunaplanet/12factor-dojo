require 'spec_helper'

describe "IV. Backing services" do
  
  it "Probado SUT contra redis version 5.0" do
    response = HTTParty.get('http://sut-a/masuno', timeout: 2)
    expect(response.code).to eq(200)
  end
  
  it "Probado SUT contra redis version 4.0" do
    response = HTTParty.get('http://sut-b/masuno', timeout: 2)
    expect(response.code).to eq(200)
  end

end
