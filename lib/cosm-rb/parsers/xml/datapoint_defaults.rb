module Cosm
  module Parsers
    module XML
      module DatapointDefaults

        include Cosm::Parsers::XML::Helpers

        def from_xml(xml)
          begin
            parsed = MultiXml.parse(xml)
            raise InvalidXMLError, "Missing 'environment' node from base node" if parsed['eeml'].nil? || !parsed['eeml'].key?('environment')
            return {} if parsed['eeml']['environment'].nil?
            datastream = parsed['eeml']['environment']['data']
            raise InvalidXMLError, "Multiple 'data' nodes are not permitted for Datapoint level XML" if datastream.is_a?(Array)
            datapoint = datastream['datapoints']
            raise InvalidXMLError, "Multiple 'value' nodes are not permitted for Datapoint level XML" if datapoint.is_a?(Array)
            _extract_datapoints(datapoint).first
          rescue MultiXml::ParseError => e
            raise InvalidXMLError, e.message
          end
        end

      end
    end
  end
end

