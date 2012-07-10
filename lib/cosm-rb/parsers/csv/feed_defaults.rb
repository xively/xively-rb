module Cosm
  module Parsers
    module CSV
      class UnknownVersionError < StandardError ; end
      class InvalidCSVError < StandardError ; end

      module FeedDefaults
        def from_csv(csv, csv_version = nil)
          rows = Cosm::CSV.parse(csv.strip)
          version = detect_version(rows, csv_version)
          hash = Hash.new
          if version == :v2
            raise InvalidCSVError, "CSV is invalid. Incorrect number of fields" if rows.sort { |a,b| a.length <=> b.length }.reverse.first.length > 3
            hash["datastreams"] = rows.collect {|row|
              timestamp = {}
              if row.size == 3
                timestamp["updated"] = row[1]
              end
              { "id" => row.first.to_s, "current_value" => row.last.to_s }.merge(timestamp)
            }
          elsif version == :v1
            hash["datastreams"] = []
            rows.first.each_with_index do |current_value, stream_id|
              hash["datastreams"] << { "id" => stream_id.to_s, "current_value" => current_value }
            end
          end
          hash["csv_version"] = version
          hash
        end

        private

        def detect_version(rows, version = nil)
          return version if version
          return :v2 if rows.size >= 2
          return :v1 if rows.size == 1 && rows.first.size != 2
          raise UnknownVersionError, "CSV Version could not be detected"
        end
      end
    end
  end
end

