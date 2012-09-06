module Cosm
  module Parsers
    module XML
      module FeedDefaults
        include Cosm::Parsers::XML::Helpers

        def from_xml(xml)
          begin
            parsed = MultiXml.parse(xml)
            raise InvalidXMLError if parsed['eeml'].nil? || parsed['eeml']['environment'].nil?
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

        # As produced by http://cosm.com/api/v2/FEED_ID.xml
        def transform_v2(xml)
          location = xml['location'] || {}
          user = xml['user'] || {}
          {
            :title => strip(xml['title']),
            :updated => strip(xml['updated']),
            :creator => strip(xml['creator']),
            :created => strip(xml['created']),
            :feed => strip(xml['feed']),
            :auto_feed_url => strip(xml['auto_feed_url']),
            :status => strip(xml['status']),
            :description => strip(xml['description']),
            :icon => strip(xml['icon']),
            :website => strip(xml['website']),
            :email => strip(xml['email']),
            :private => strip(xml['private']),
            :location_lon => strip(location['lon']),
            :location_lat => strip(location['lat']),
            :location_ele => strip(location['ele']),
            :location_name => strip(location['name']),
            :location_domain => strip(location['domain']),
            :location_exposure => strip(location['exposure']),
            :location_disposition => strip(location['disposition']),
            :owner_login => strip(user['login']),
            :datastreams => _extract_datastreams(xml['data'])
          }.merge(sanitised_tags(xml))
        end

        # As produced by http://cosm.com/api/v1/FEED_ID.xml
        def transform_v1(xml)
          location = xml['location'] || {}
          user = xml['user'] || {}
          {
            :title => strip(xml['title']),
            :updated => strip(xml['updated']),
            :creator => 'http://www.haque.co.uk',
            :created => strip(xml['created']),
            :feed => strip(xml['feed']),
            :status => strip(xml['status']),
            :description => strip(xml['description']),
            :icon => strip(xml['icon']),
            :website => strip(xml['website']),
            :email => strip(xml['email']),
            :location_lon => strip(location['lon']),
            :location_lat => strip(location['lat']),
            :location_ele => strip(location['ele']),
            :location_name => strip(location['name']),
            :location_domain => strip(location['domain']),
            :location_exposure => strip(location['exposure']),
            :location_disposition => strip(location['disposition']),
            :datastreams => _extract_datastreams_v1(xml['data'])
          }
        end

      end
    end
  end
end

