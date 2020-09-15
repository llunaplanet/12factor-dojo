require 'spec_helper'

describe "VI. Processes" do

  willy_cookies = Hash.new

  it "I tell the SUT my name and the SUT greets me back" do
    response_willy = HTTParty.get('http://proxy/saymyname?name=Willy', timeout: 2)
    expect(response_willy.code).to eq(200)
    expect(response_willy.body).to eq("Hi Willy, nice to meet you!")

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

  it "The SUT sent me a cookie" do
    expect(willy_cookies).to have_key("connect.sid")
  end

  it "The SUT is able to remember my name" do
    response_a = HTTParty.get('http://proxy/whoami', timeout: 2, cookies: willy_cookies)
    response_b = HTTParty.get('http://proxy/whoami', timeout: 2, cookies: willy_cookies)
    expect(response_a.code).to eq(200)
    expect(response_a.body).to eq("Willy")
    expect(response_b.body).to eq("Willy")
  end

end
