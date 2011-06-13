module PachubeDataFormats
  module Parsers
    module CSV
      class UnknownVersionError < StandardError ; end
      module FeedDefaults
        def from_csv(csv, csv_version = nil)
          array = ::CSV.parse(csv.strip)
          version = detect_version(array, csv_version)
          hash = Hash.new
          if version == :v2
            hash["datastreams"] = array.collect {|row|
              { "id" => row.first.to_s,
                "current_value" => row.last.to_s
              }
            }
          elsif version == :v1
            hash["datastreams"] = []
            array.first.each_with_index do |current_value, stream_id|
              hash["datastreams"] << { "id" => stream_id, "current_value" => current_value }
            end
          end
          hash
        end

        private

        def detect_version(array, version = nil)
          return version if version
          return :v2 if array.size >= 2
          return :v1 if array.size == 1 && array.first.size != 2
          raise UnknownVersionError, "CSV Version could not be detected"
        end
      end
    end
  end
end

