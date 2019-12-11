require 'spec_helper'

describe "XI. Treat logs as event streams" do
  
  let(:docker_host) { ENV.fetch("DOCKER_HOST").gsub("tcp","http") }
  
  it "Esperamos ver el stack trace del 500 en stdout" do
    response = HTTParty.get('http://sut-a/dameun500')
    expect(response.code).to eq(500)
    
    container_list_response = HTTParty.get("#{docker_host}/v1.38/containers/json")
    container_list = JSON.parse(container_list_response.body)
    sut_container = container_list.select { |item| item["Names"].include?("/test11_sut-a_1") || item["Names"].include?("/testall_sut-a_1")}.first
    container_id = sut_container["Id"]
    container_logs_response = HTTParty.get("#{docker_host}/v1.38/containers/#{container_id}/logs?stdout=true")
    expect(container_logs_response.code).to eq(200)
    expect(container_logs_response.body).to include("Toma un 500!")

  end

end
