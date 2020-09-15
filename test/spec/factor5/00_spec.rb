require 'spec_helper'

describe "V. Strictly separate build and run stages" do

  it "Staging environment greets us" do
    response = HTTParty.get('http://sut-a/index.html')
    expect(response.code).to eq(200)
    expect(response.body).to eq("Greetings from the [staging] environment!\n")
  end

  it "QA environment greets us" do
    response = HTTParty.get('http://sut-b/index.html')
    expect(response.code).to eq(200)
    expect(response.body).to eq("Greetings from the [qa] environment!\n")
  end

end
