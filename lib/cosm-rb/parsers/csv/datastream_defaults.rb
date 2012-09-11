module Cosm
  module Parsers
    module CSV
      module DatastreamDefaults
        def from_csv(csv, csv_version = nil)
          begin
            rows = Cosm::CSV.parse(csv.strip)
          rescue Exception => e
            # this might be a FasterCSV or CSV exception depending on whether
            # we are running under 1.8.x or 1.9.x
            raise InvalidCSVError, e.message
          end

          version = FeedDefaults.detect_version(rows, csv_version)

          raise InvalidCSVError, "CSV is invalid. Submitted data appears to be empty" if rows.nil?

          if version == :v1
            raise InvalidCSVError, "CSV is invalid. Can only construct a Cosm::Datastream object from a single row of data" if rows.size > 1
            row = rows.first
            raise InvalidCSVError, "CSV is invalid. Too many fields; must only be a single value" if row.size > 1
            return { "current_value" => row[0].to_s.strip }
          else
            row_sizes = rows.collect { |row| row.size }.uniq
            raise InvalidCSVError, "CSV is invalid. Too many fields; must only be a single value, or a timestamp and a value" if row_sizes.max > 2

            if rows.size == 1
              # capture single lines (normal case)
              row = rows.first

              if row.size == 2
                return { "updated" => row[0].to_s.strip, "current_value" => row[1].to_s.strip }
              else
                return { "current_value" => row[0].to_s.strip }
              end
            else
              # capture multiple lines
              raise InvalidCSVError, "CSV is invalid. If multiple values are included, then a timestamp and value must be submitted for every row" if row_sizes.min < 2

              return { "datapoints" => rows.collect { |row| { "at" => row[0].to_s.strip, "value" => row[1].to_s.strip } } }
            end
          end

        end

      end
    end
  end
end

