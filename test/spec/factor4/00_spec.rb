require 'spec_helper'

describe "IV. Backing services" do

  it "SUT works with redis version 5.0" do
    response = HTTParty.get('http://sut-a/plusone', timeout: 2)
    expect(response.code).to eq(200)
  end

  it "SUT works with redis version 4.0" do
    response = HTTParty.get('http://sut-b/plusone', timeout: 2)
    expect(response.code).to eq(200)
  end

end
