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
            return datastreams.collect do |datastream|
              "#{datastream.feed_id},#{datastream.id},#{datastream.updated.iso8601(6)},#{datastream.current_value}"
            end.join("\n")
          else
            return datastreams.collect do |datastream|
              "#{datastream.id},#{datastream.updated.iso8601(6)},#{datastream.current_value}"
            end.join("\n")
          end
        end

        def csv_1
          return datastreams.collect do |datastream|
            datastream.current_value
          end.join(',')
        end
      end
    end
  end
end

