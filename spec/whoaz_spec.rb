require 'spec_helper'

describe 'main page' do
  it "should redirect to gem homepage" do
    get '/'
    last_response.should be_redirect
    follow_redirect!
    last_request.url.should == 'http://narkoz.github.com/whoaz'
  end
end

describe 'domain query' do
  it "should return domain info in json format" do
    get '/v1/google.az'
    last_response.status.should == 200
    last_response.body.should have_json_size(1).at_path('domain')
    last_response.body.should have_json_size(2).at_path('nameservers')
  end
end

describe 'not found' do
  it "should return 404" do
    get '/v1'
    last_response.status.should == 404
    error = {:message => 'Not found'}
    last_response.body.should be_json_eql(error.to_json)
  end
end
