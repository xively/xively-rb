module Cosm
  module Parsers
    module CSV
      class UnknownVersionError < Cosm::ParserError ; end
      class InvalidCSVError < Cosm::ParserError ; end

      module FeedDefaults
        def from_csv(csv, csv_version = nil)
          begin
            rows = Cosm::CSV.parse(csv.strip)
          rescue Exception => e
            # this might be a FasterCSV or CSV exception depending on whether
            # we are running under 1.8.x or 1.9.x
            raise InvalidCSVError, e.message
          end
          version = detect_version(rows, csv_version)
          hash = Hash.new
          if version == :v2
            raise InvalidCSVError, "CSV is invalid. Incorrect number of fields" if rows.sort { |a,b| a.length <=> b.length }.reverse.first.length > 3
            hash["datastreams"] = rows.collect {|row|
              timestamp = {}
              if row.size == 3
                timestamp["updated"] = row[1].strip
              end
              { "id" => row.first.to_s.strip, "current_value" => row.last.to_s.strip }.merge(timestamp)
            }
          elsif version == :v1
            raise InvalidCSVError, "CSV is invalid. Currently we can only accept CSV for your most recent set of values. You have submitted 2 rows of data." if rows.size > 1
            hash["datastreams"] = []
            rows.first.each_with_index do |current_value, stream_id|
              hash["datastreams"] << { "id" => stream_id.to_s.strip, "current_value" => current_value.to_s.strip }
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

