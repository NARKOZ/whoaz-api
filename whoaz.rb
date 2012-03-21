require 'sinatra'
require 'whoaz'
require 'json'

get '/' do
  redirect 'http://narkoz.github.com/whoaz'
end

get '/v1/:domain' do
  content_type :json

  begin
    query = Whoaz.whois params[:domain]
  rescue Whoaz::Error => e
    data = {:message => e.message}
  else
    data = {
      :domain => params[:domain],
      :nameservers => query.nameservers,
      :registrant => {
        :organization => query.organization,
        :name => query.name,
        :address => query.address,
        :phone => query.phone,
        :fax => query.fax,
        :email => query.email
      }
    }
  end
  data = {:message => 'Domain not registered'} if query && query.free?
  data.to_json
end

not_found do
  content_type :json
  {:message => 'Not found'}.to_json
end

error do
  'Please reload the page or try again in a moment.'
end
