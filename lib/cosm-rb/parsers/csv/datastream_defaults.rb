module Cosm
  module Parsers
    module CSV
      module DatastreamDefaults
        def from_csv(csv, csv_version = nil)
          rows = Cosm::CSV.parse(csv.strip)
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

