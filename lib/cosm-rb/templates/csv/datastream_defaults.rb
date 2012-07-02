module Cosm
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
          options[:depth] = 4 if options[:full]
          case options[:depth].to_i
          when 4
            datapoints.collect {|datapoint| csv << [feed_id, id, datapoint.at.iso8601(6), datapoint.value] }
            csv << [feed_id, id, updated.iso8601(6), current_value] if csv.empty?
          when 3
            datapoints.collect {|datapoint| csv << [id, datapoint.at.iso8601(6), datapoint.value] }
            csv << [id, updated.iso8601(6), current_value] if csv.empty?
          when 1
            datapoints.collect {|datapoint| csv << [datapoint.value] }
            csv << [current_value] if csv.empty?
          else
            datapoints.collect {|datapoint| csv << [datapoint.at.iso8601(6), datapoint.value] }
            csv << [updated.iso8601(6), current_value] if csv.empty?
          end
          csv.collect {|row| Cosm::CSV.generate_line(row).strip }.join("\n")
        end

        def csv_1
          Cosm::CSV.generate_line([current_value]).strip
        end
      end
    end
  end
end

