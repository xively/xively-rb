module Xively
  module Templates
    module XML
      module DatapointDefaults
        include XMLHeaders
        def generate_xml(version = nil)
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.eeml(_eeml_0_5_1) do |eeml|
              eeml.environment do |environment|
                environment.data do |data|
                  data.datapoints do |datapoints|
                    datapoints.value(value, :at => at.iso8601(6))
                  end
                end
              end
            end
          end
          builder.to_xml
        end

      end
    end
  end
end

