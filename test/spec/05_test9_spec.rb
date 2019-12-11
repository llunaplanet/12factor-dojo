require 'spec_helper'

describe "IX. Maximize robustness with fast startup and graceful shutdown" do
  
  let(:docker_host) { ENV.fetch("DOCKER_HOST").gsub("tcp","http") }
  
  it "Al parar el container debe dejar de procesar peticiones" do
    
    container_list_response = HTTParty.get("#{docker_host}/v1.38/containers/json")
    container_list = JSON.parse(container_list_response.body)
    sut_container = container_list.select { |item| item["Names"].include?("/test9_sut-a_1") || item["Names"].include?("/testall_sut-a_1")}.first
    container_id = sut_container["Id"]
    
    5.times { HTTParty.get('http://sut-a/masuno') }
    
    fork do
      begin
        sleep(3)  
        5.times { HTTParty.get('http://sut-a/masuno') }
      rescue  
        # nothing to do
      end
    end
    
    # Stop the container
    container_stop_response = HTTParty.post("#{docker_host}/v1.38/containers/#{container_id}/stop?t=5")
    expect(container_stop_response.code).to eq(204)
    
    redis = Redis.new(host: "redis-a", password: "passwordA")
    masuno = redis.get("masuno")

    expect(masuno.to_i).to be <= 6

  end

end
