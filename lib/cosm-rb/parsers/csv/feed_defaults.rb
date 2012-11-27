module Cosm
  module Parsers
    module CSV
      class UnknownVersionError < Cosm::ParserError ; end
      class InvalidCSVError < Cosm::ParserError ; end

      module FeedDefaults

        class << self
          def detect_version(rows, version = nil)
            return version if version
            return :v2 if rows.size >= 2
            return :v1 if rows.size == 1 && rows.first.size != 2
            raise UnknownVersionError, "CSV Version could not be detected"
          end
        end

        def from_csv(csv, csv_version = nil)
          begin
            rows = Cosm::CSV.parse(csv.strip)
          rescue Exception => e
            # this might be a FasterCSV or CSV exception depending on whether
            # we are running under 1.8.x or 1.9.x
            raise InvalidCSVError, e.message
          end

          version = FeedDefaults.detect_version(rows, csv_version)

          hash = Hash.new

          if version == :v2
            hash["datastreams"] = extract_datastreams(rows)
          elsif version == :v1
            raise InvalidCSVError, "CSV is invalid. Currently we can only accept CSV for your most recent set of values. You have submitted #{rows.size} rows of data." if rows.size > 1
            hash["datastreams"] = []
            rows.first.each_with_index do |current_value, stream_id|
              hash["datastreams"] << { "id" => stream_id.to_s.strip, "current_value" => current_value.to_s.strip }
            end
          end
          hash["csv_version"] = version
          hash
        end

        private

        # This is used by v2 only
        def extract_datastreams(rows)
          row_sizes = rows.collect { |row| row.size }.uniq
          row_ids = rows.collect { |row| row.first.to_s.strip }.uniq

          raise InvalidCSVError, "CSV is invalid. Incorrect number of fields" if row_sizes.max > 3 || row_sizes.min <= 1

          datastream_buckets = {}

          # iterate through each row bucketing by datastream id
          rows.each do |row|
            # this splits each row into the id first element, and an array containing the rest of the row
            id, *rest = *row

            # make empty array if it doesn't exist
            datastream_buckets[id.to_s.strip] ||= []
            # add this row to the correct bucketed array
            datastream_buckets[id.to_s.strip] << rest
          end

          datastreams = []

          row_ids.each do |datastream_id|
            datastream_data = datastream_buckets[datastream_id]

            if datastream_data.size == 1
              # single value for this datastream - current normal
              data = datastream_data[0]
              if data.size == 2
                datastreams << { "id" => datastream_id, "updated" => data[0].to_s.strip, "current_value" => data[1].to_s.strip }
              else
                datastreams << { "id" => datastream_id, "current_value" => data[0].to_s.strip }
              end
            else
              # multiple values for this datastream
              raise InvalidCSVError, "CSV is invalid. If multiple values given they must include a timestamp for all values" if datastream_data.collect { |d| d.size }.min < 2

              datapoints = datastream_data.collect { |datapoint_data| { "at" => datapoint_data[0].to_s.strip, "value" => datapoint_data[1].to_s.strip } }

              datastreams << { "id" => datastream_id, "datapoints" => datapoints }
            end
          end

          return datastreams
        end
      end
    end
  end
end

