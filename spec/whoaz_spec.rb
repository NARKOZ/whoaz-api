require 'spec_helper'

describe 'main page' do
  it "should redirect to gem homepage" do
    get '/'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to eq('https://narkoz.github.io/whoaz')
  end
end

describe 'domain query' do
  it "should return domain info in json format" do
    get '/v1/google.az'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to have_json_path('domain')
    expect(last_response.body).to have_json_path('raw_domain_info')
    expect(last_response.body).to have_json_size(2).at_path('nameservers')
    expect(last_response.body).to have_json_size(6).at_path('registrant')
  end
end

describe 'not found' do
  it "should return 404" do
    get '/v1'
    expect(last_response.status).to eq(404)
    error = { message: 'Not found' }
    expect(last_response.body).to be_json_eql(error.to_json)
  end
end
