require 'spec_helper'

describe "V. Strictly separate build and run stages" do
  
  it "El entorno de staging nos saluda" do
    response = HTTParty.get('http://sut-a/index.html')
    expect(response.code).to eq(200)
    expect(response.body).to eq("Saludos desde el entorno [staging]!\n")
  end
  
  it "El entorno de qa nos saluda" do
    response = HTTParty.get('http://sut-b/index.html')
    expect(response.code).to eq(200)
    expect(response.body).to eq("Saludos desde el entorno [qa]!\n")
  end

end
