require 'sinatra'
require 'whoaz'
require 'redis'

REDIS = Redis.new(url: ENV['REDIS_URL'])

get '/' do
  redirect 'https://narkoz.github.io/whoaz'
end

get '/v1/:domain' do
  content_type :json

  key = "whoaz_domain:#{params[:domain]}"
  REDIS.exists(key) ? REDIS.incr(key) : REDIS.set(key, 1)

  begin
    domain = Whoaz.whois params[:domain]
  rescue Whoaz::Error => e
    data = { message: e.message }
  else
    data = {
      domain: params[:domain],
      nameservers: domain.nameservers,
      registrant: {
        organization: domain.organization,
        name: domain.name,
        address: domain.address,
        phone: domain.phone,
        fax: domain.fax,
        email: domain.email
      },
      raw_domain_info: domain.raw_domain_info
    }
  end

  data = { message: 'Domain not registered' } if domain && domain.free?
  data.to_json
end

not_found do
  content_type :json
  { message: 'Not found' }.to_json
end

error do
  'Please reload the page or try again in a moment.'
end
