require 'spec_helper'

describe "VI. Processes" do
  # before(:all) do
  # 
  #   # wait for suts to be ready
  #   starting = Time.now
  #   response = HTTParty.get('http://sut-a/masuno') 
  #   puts "Waiting for SUT A"
  #   while response.code != 200
  #     response = HTTParty.get('http://sut-a/masuno') 
  #     ending = Time.now
  #     elapsed = ending - starting
  #     if(elapsed > 4) 
  #       break
  #     end
  #   end
  #   puts response.code
  # 
  #   puts "Waiting for SUT B"
  #   starting = Time.now
  #   response = HTTParty.get('http://sut-b/masuno') 
  # 
  #   while response.code != 200
  #     response = HTTParty.get('http://sut-b/masuno') 
  #     ending = Time.now
  #     elapsed = ending - starting
  #     if(elapsed > 4) 
  #       break
  #     end
  #   end
  # 
  #   puts response.code
  # 
  #   sleep(10)
  # 
  # end

  willy_cookies = Hash.new
  
  it "Me presento como Willy y el sut me devuelve el saludo" do
    response_willy = HTTParty.get('http://proxy/diminombre?nombre=Willy', timeout: 2)
    expect(response_willy.code).to eq(200)
    expect(response_willy.body).to eq("Hola Willy, encantado de conocerte")
    
    set_cookie_header = response_willy.get_fields('Set-Cookie')
    
    set_cookie_header[0].split(',').each {
      |single_cookie_string|
      cookie_part_string  = single_cookie_string.strip.split(';')[0]
      cookie_part         = cookie_part_string.strip.split('=')
      key                 = cookie_part[0]
      value               = cookie_part[1]
      willy_cookies[key] = value
    }
  
  end
  
  it "El sut me ha enviado una cookie" do  
    expect(willy_cookies).to have_key("connect.sid")
  end
  
  it "El sut es capaz de recordar mi nombre" do
    response_a = HTTParty.get('http://proxy/quiensoy', timeout: 2, cookies: willy_cookies)
    response_b = HTTParty.get('http://proxy/quiensoy', timeout: 2, cookies: willy_cookies)
    expect(response_a.code).to eq(200)
    expect(response_a.body).to eq("Willy")
    expect(response_b.body).to eq("Willy")
  end

end
