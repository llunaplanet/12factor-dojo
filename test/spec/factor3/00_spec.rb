require 'spec_helper'

describe "III. Store config in the environment" do

  it "I expect a MOT in English" do
    response = HTTParty.get('http://sut-a/greetings', timeout: 2)
    expect(response.code).to eq(200)
    expect(response.body).to eq("What's Up?")
  end

  it "I expect a MOT in Spanish" do
    response = HTTParty.get('http://sut-b/greetings', timeout: 2)
    expect(response.code).to eq(200)
    expect(response.body).to eq("¿Qué pasa pisha?")
  end

end
