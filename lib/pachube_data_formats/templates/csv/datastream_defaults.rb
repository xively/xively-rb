module PachubeDataFormats
  module Templates
    module CSV
      module DatastreamDefaults
        def generate_csv(version, options = {})
          case version
          when "2"
            csv_2(options)
          when "1"
            csv_1
          end
        end

        private

        def csv_2(options)
          if options[:full]
            "#{feed_id},#{id},#{updated.iso8601(6)},#{current_value}"
          else
            "#{updated.iso8601(6)},#{current_value}"
          end
        end

        def csv_1
          current_value
        end
      end
    end
  end
end

