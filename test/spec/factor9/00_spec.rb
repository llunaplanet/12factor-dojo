require 'spec_helper'

describe "IX. Maximize robustness with fast startup and graceful shutdown" do

  let(:docker_host) { ENV.fetch("DOCKER_HOST").gsub("tcp","http") }

  it "The SUT should answer although it's dependencies are not ready" do

    response = HTTParty.get('http://sut-b/enqueue', timeout: 5)
    expect(response.code).to eq(503)

  end

  it "Once SUT's dependencies are ready, the SUT should answer normally" do

    # Send SIGUSR1 to slownats
    container_id = get_container_id(docker_host, ["/factor9_nats-slow_1","/all_nats-slow_1"])
    send_signal_response = HTTParty.post("#{docker_host}/v1.38/containers/#{container_id}/kill?signal=SIGUSR1")

    expect(send_signal_response.code).to eq(204)

    response = HTTParty.get('http://sut-b/enqueue', timeout: 1)

    # wait for nats to start
    starting = Time.now

    while response.code != 200
      response = HTTParty.get('http://sut-b/enqueue', timeout: 5)
      ending = Time.now
      elapsed = ending - starting
      sleep(1)
      if(elapsed > 10)
        break
      end
    end

    expect(response.code).to eq(200)

  end

  it "When stopping the SUT it should stop accepting requests gracefully while it shuts down" do

    @respose_codes = []

    redis = Redis.new(host: "redis-a", password: "passwordA")
    plusone = redis.set("plusone", 0)

    5.times {
      response = HTTParty.get('http://sut-a/plusone', timeout: 2)
      @respose_codes.push(response.code)
    }

    Thread.fork do
      5.times {
        begin
          sleep(1)
          response = HTTParty.get('http://sut-a/plusone', timeout: 2)
          @respose_codes.push(response.code)
        rescue
        end
      }
    end

    # Stop the sut container
    container_id = get_container_id(docker_host, ["/factor9_sut-a_1","/all_sut-a_1"])
    container_stop_response = HTTParty.post("#{docker_host}/v1.38/containers/#{container_id}/stop?t=5")
    expect(container_stop_response.code).to eq(204)

    response_200_count = @respose_codes.select { |code| code == 200 }.length
    response_503_count = @respose_codes.select { |code| code == 503 }.length

    plusone = redis.get("plusone")

    expect(plusone.to_i).to eq(response_200_count)
    expect(response_503_count).to be > 0

  end

end
