module PachubeDataFormats
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
          if options[:full]
            csv = datastreams.collect { |datastream| ::CSV.generate_line([id, datastream.id, datastream.updated.iso8601(6), datastream.current_value]) }
          else
            csv = datastreams.collect { |datastream| ::CSV.generate_line([datastream.id, datastream.updated.iso8601(6), datastream.current_value]) }
          end
          csv.join("\n")
        end

        def csv_1
          ::CSV.generate_line datastreams.collect {|ds| ds.current_value }
        end
      end
    end
  end
end

