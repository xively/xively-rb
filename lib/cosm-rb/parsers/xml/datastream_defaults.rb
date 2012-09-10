module Cosm
  module Parsers
    module XML
      module DatastreamDefaults
        include Cosm::Parsers::XML::Helpers

        def from_xml(xml)
          begin
            parsed = MultiXml.parse(xml)
            raise InvalidXMLError, "Missing 'environment' node from base node" if parsed['eeml'].nil? || !parsed['eeml'].key?('environment')
            return {} if parsed['eeml']['environment'].nil?
            if parsed['eeml']['version'] == '5' || parsed['eeml']['xmlns'] == 'http://www.eeml.org/xsd/005'
              transform_v1(parsed['eeml']['environment'])
            else
              transform_v2(parsed['eeml']['environment'])
            end
          rescue MultiXml::ParseError => e
            raise InvalidXMLError, e.message
          end
        end

        private

        # As produced by http://cosm.com/api/v2/FEED_ID/datastreams/DATASTREAM_ID.xml
        def transform_v2(xml)
          datastream = convert_to_hash(xml['data'])
          _extract_datastream(datastream).merge({
            :feed_id => strip(xml,'id'),
            :feed_creator => strip(xml,'creator')
          })
        end

        # As produced by http://cosm.com/api/v1/FEED_ID/datastreams/DATASTREAM_ID.xml
        def transform_v1(xml)
          datastream = convert_to_hash(xml['data'])
          _extract_datastream_v1(datastream).merge({
            :feed_id => strip(xml,'id'),
            :updated => strip(xml,'updated'),
            :feed_creator => 'http://www.haque.co.uk'
          })
        end

      end
    end
  end
end

