require 'httparty'
module Cosm
  class Client
    include HTTParty
    base_uri 'https://api.cosm.com'

    attr_accessor :api_key

    def self.user_agent
      "cosm-rb/#{Cosm::VERSION}"
    end

    def initialize(api_key)
      @api_key = api_key
    end

    def get(url, options = {})
      self.class.get(url, parse_options(options))
    end

    def delete(url, options = {})
      self.class.delete(url, parse_options(options))
    end

    def put(url, options = {})
      self.class.put(url, parse_options(options))
    end

    def post(url, options = {})
      self.class.post(url, parse_options(options))
    end

    private

    def parse_options(options = {})
      new_options = options.clone
      new_options[:headers] ||= {}
      new_options[:headers].merge!("User-Agent" => self.class.user_agent, "X-ApiKey" => api_key)
      new_options
    end

  end
end
