require 'spec_helper'

describe "IX. Maximize robustness with fast startup and graceful shutdown" do
  
  let(:docker_host) { ENV.fetch("DOCKER_HOST").gsub("tcp","http") }
  
  it "El sut debe contestar aunque las dependencias no estén disponibles" do
    
    response = HTTParty.get('http://sut-b/encolame', timeout: 5)
    expect(response.code).to eq(503)

  end
  
  it "Una vez las dependencias están disponibles debe contestar con normalidad" do

    # Send SIGUSR1 to slowredis
    container_id = get_container_id(docker_host, ["/factor9_nats-slow_1","/testall_nats-slow_1"])
    send_signal_response = HTTParty.post("#{docker_host}/v1.38/containers/#{container_id}/kill?signal=SIGUSR1")
    
    expect(send_signal_response.code).to eq(204)
    
    response = HTTParty.get('http://sut-b/encolame', timeout: 1) 
    
    # wait for nats to start
    starting = Time.now
    
    while response.code != 200
      response = HTTParty.get('http://sut-b/encolame', timeout: 5) 
      ending = Time.now
      elapsed = ending - starting
      sleep(1)
      if(elapsed > 10) 
        break
      end
    end

    expect(response.code).to eq(200)

  end
  
  it "Al parar el container debe dejar de procesar peticiones" do
    
    5.times { HTTParty.get('http://sut-a/masuno', timeout: 2) }
    
    fork do
      begin
        sleep(3)  
        5.times { HTTParty.get('http://sut-a/masuno', timeout: 2) }
      rescue  
        # nothing to do
      end
    end
    
    # Stop the redis container
    container_id = get_container_id(docker_host, ["/factor9_sut-a_1","/testall_sut-a_1"])
    container_stop_response = HTTParty.post("#{docker_host}/v1.38/containers/#{container_id}/stop?t=5")
    expect(container_stop_response.code).to eq(204)
    
    redis = Redis.new(host: "redis-a", password: "passwordA")
    masuno = redis.get("masuno")

    expect(masuno.to_i).to be <= 6

  end

end
