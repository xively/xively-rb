module PachubeDataFormats
  module Generator
    def generate(hash)
      raise "Implement self.generate(hash)"
    end
  end

  module Parser
    def parse(input)
      raise "Implement self.parse(input)"
    end
  end
end

require 'yajl/json_gem'
require 'pachube_data_formats/feed_formats/json'
require 'pachube_data_formats/feed_formats/hash'
require 'pachube_data_formats/feed'

