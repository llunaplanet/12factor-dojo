require 'spec_helper'

describe "XI. Treat logs as event streams" do
  
  let(:docker_host) { ENV.fetch("DOCKER_HOST").gsub("tcp","http") }
  
  it "Esperamos ver el stack trace del 500 en stdout" do
    response = HTTParty.get('http://sut-a/dameun500')
    expect(response.code).to eq(500)
    
    # Get container logs
    container_id = get_container_id(docker_host, ["/factor11_sut-a_1","/testall_sut-a_1"])
    container_logs_response = HTTParty.get("#{docker_host}/v1.38/containers/#{container_id}/logs?stdout=true")
    
    expect(container_logs_response.code).to eq(200)
    expect(container_logs_response.body).to include("Toma un 500!")

  end

end
