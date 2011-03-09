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
          csv = []
          if options[:complete] || datapoints.empty?
            if options[:full]
              csv << "#{feed_id},#{id},#{updated.iso8601(6)},#{current_value}"
            else
              csv << "#{updated.iso8601(6)},#{current_value}"
            end
          end
          datapoints.each do |datapoint|
            if options[:full]
              csv << "#{feed_id},#{id},#{datapoint.at.iso8601(6)},#{datapoint.value}"
            else
              csv << "#{datapoint.at.iso8601(6)},#{datapoint.value}"
            end
          end
          csv.join("\n")
        end

        def csv_1
          current_value
        end
      end
    end
  end
end

