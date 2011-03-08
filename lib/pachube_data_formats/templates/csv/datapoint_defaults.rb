module PachubeDataFormats
  module Templates
    module CSV
      module DatapointDefaults
        def generate_csv(options = {})
          if options[:full]
            "#{feed_id},#{datastream_id},#{at.iso8601(6)},#{value}"
          else
            value
          end
        end
      end
    end
  end
end

