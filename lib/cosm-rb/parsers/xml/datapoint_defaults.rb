module Cosm
  module Parsers
    module XML
      module DatapointDefaults

        include Cosm::Parsers::XML::Helpers

        def from_xml(xml)
          begin
            parsed = MultiXml.parse(xml)
            raise InvalidXMLError if parsed['eeml'].nil? || parsed['eeml']['environment'].nil?
            datastream = parsed['eeml']['environment']['data']
            datapoint = datastream['datapoints']
            _extract_datapoint(datapoint)
          rescue MultiXml::ParseError => e
            raise InvalidXMLError, e.message
          end
        end

      end
    end
  end
end

