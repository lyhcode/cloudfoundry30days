# require 'rubygems'
require 'sinatra'

get '/env' do
    #"Hello from Cloud Foundry"
    ENV['VCAP_SERVICES']
end

# get '/mu-2f5eccb1-0338f64d-6d88faad-74d6c823' do
#  '42'
# end
