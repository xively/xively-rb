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
          if options[:full]
            datapoints.collect {|datapoint| csv << [feed_id, id, datapoint.at.iso8601(6), datapoint.value] }
            csv << [feed_id, id, updated.iso8601(6), current_value] if csv.empty?
          else
            datapoints.collect {|datapoint| csv << [datapoint.at.iso8601(6), datapoint.value] }
            csv << [updated.iso8601(6), current_value] if csv.empty?
          end
          csv.collect {|row| ::CSV.generate_line(row) }.join("\n")
        end

        def csv_1
          ::CSV.generate_line([current_value])
        end
      end
    end
  end
end

