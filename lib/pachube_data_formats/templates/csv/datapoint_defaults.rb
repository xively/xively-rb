module PachubeDataFormats
  module Templates
    module CSV
      module DatapointDefaults
        def generate_csv(version, options = {})
          if options[:full]
            ::CSV.generate_line([feed_id, datastream_id, at.iso8601(6), value])
          else
            ::CSV.generate_line([value])
          end
        end
      end
    end
  end
end

