module Cosm
  module Templates
    module CSV
      module DatapointDefaults
        def generate_csv(version, options = {})
          options[:depth] = 4 if options[:full]
          case options[:depth].to_i
          when 4
            Cosm::CSV.generate_line([feed_id, datastream_id, at.iso8601(6), value]).strip
          when 3
            Cosm::CSV.generate_line([datastream_id, at.iso8601(6), value]).strip
          when 2
            Cosm::CSV.generate_line([at.iso8601(6), value]).strip
          else
            Cosm::CSV.generate_line([value]).strip
          end
        end
      end
    end
  end
end

