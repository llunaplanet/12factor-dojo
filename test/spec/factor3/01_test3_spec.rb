require 'spec_helper'

describe "III. Store config in the environment" do
  
  it "Espero un MOT en vasco" do
    response = HTTParty.get('http://sut-a/saludos', timeout: 2)
    expect(response.code).to eq(200)
    expect(response.body).to eq("Aupaaaa!")
  end
  
  it "Espero un MOT en andalú" do
    response = HTTParty.get('http://sut-b/saludos', timeout: 2)
    expect(response.code).to eq(200)
    expect(response.body).to eq("¿Qué pasa pisha?")
  end

end
