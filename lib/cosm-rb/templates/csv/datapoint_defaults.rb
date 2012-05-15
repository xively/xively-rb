module Cosm
  module Templates
    module CSV
      module DatapointDefaults
        def generate_csv(version, options = {})
          options[:depth] = 4 if options[:full]
          case options[:depth].to_i
          when 4
            ::CSV.generate_line([feed_id, datastream_id, at.iso8601(6), value])
          when 3
            ::CSV.generate_line([datastream_id, at.iso8601(6), value])
          when 2
            ::CSV.generate_line([at.iso8601(6), value])
          else
            ::CSV.generate_line([value])
          end
        end
      end
    end
  end
end

