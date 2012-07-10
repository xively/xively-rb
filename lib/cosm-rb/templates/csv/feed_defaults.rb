module Cosm
  module Templates
    module CSV
      module FeedDefaults
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
            datastreams.collect do |datastream|
              if datastream.datapoints.any?
                datastream.datapoints.collect { |datapoint| csv << Cosm::CSV.generate_line([id, datastream.id, datapoint.at.iso8601(6), datapoint.value]).strip }
              else
                csv << Cosm::CSV.generate_line([id, datastream.id, datastream.updated.iso8601(6), datastream.current_value]).strip
              end
 

            end
          else
            datastreams.collect do |datastream|
              if datastream.datapoints.any?
                datastream.datapoints.collect { |datapoint| csv << Cosm::CSV.generate_line([datastream.id, datapoint.at.iso8601(6), datapoint.value]).strip }
              else
                csv << Cosm::CSV.generate_line([datastream.id, datastream.updated.iso8601(6), datastream.current_value]).strip
              end
            end
          end
          csv.join("\n")
        end

        def csv_1
          Cosm::CSV.generate_line(datastreams.collect {|ds| ds.current_value }).strip
        end
      end
    end
  end
end

