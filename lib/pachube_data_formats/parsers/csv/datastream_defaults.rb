module PachubeDataFormats
  module Parsers
    module CSV
      module DatastreamDefaults
        def from_csv(csv)
          {"current_value" => ::CSV.parse(csv.strip).first.first.to_s}
        end
      end
    end
  end
end

