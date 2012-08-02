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
          raise InvalidCSVError, "CSV is invalid. Can only construct a Cosm::Datastream object from a single row of data" if rows.size > 1
          row = rows.first
          raise InvalidCSVError, "CSV is invalid. Too many fields; must only be a single value, or a timestamp and a value" if row.size > 2
          if row.size == 2
            return { "updated" => row[0], "current_value" => row[1].to_s }
          else
            return { "current_value" => row[0].to_s }
          end
        end
      end
    end
  end
end

