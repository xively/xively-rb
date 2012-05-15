require 'httparty'
module Cosm
  class Client
    include HTTParty
    base_uri 'https://api.cosm.com'
  end
end
