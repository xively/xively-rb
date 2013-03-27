module Cosm
  module Templates
    module XML
      module FeedDefaults
        include XMLHeaders
        include Helpers

        def generate_xml(version, options={})
          case version
          when "0.5.1"
            xml_0_5_1 options
          when "5"
            xml_5 options
          end
        end

        private

        # As used by http://cosm.com/api/v2/FEED_ID/datastreams/DATASTREAM_ID.xml
        def xml_0_5_1(options={})
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.eeml(_eeml_0_5_1) do |eeml|
              eeml.environment(:updated => updated.iso8601(6), :created => created.iso8601(6), :id => id, :creator => creator) do |environment|
                environment.title title unless title.blank?
                environment.feed "#{feed}.xml" unless feed.blank?
                environment.auto_feed_url auto_feed_url unless auto_feed_url.blank?
                environment.status status unless status.blank?
                environment.description description unless description.blank?
                environment.icon icon unless icon.blank?
                environment.website website unless website.blank?
                environment.email email unless email.blank?
                environment.product_id product_id unless product_id.blank?
                environment.device_serial device_serial unless device_serial.blank?
                environment.private_ self.private.to_s
                parse_tag_string(tags).each do |tag|
                  environment.tag tag
                end if tags
                environment.location({:disposition => location_disposition, :exposure => location_exposure, :domain => location_domain}.delete_if_nil_value) do |location|
                  location.name location_name
                  location.lat location_lat
                  location.lon location_lon
                  location.ele location_ele
                end
                environment.user do |user|
                  user.login owner_login
                end if owner_login
                datastreams.each do |ds|
                  environment.data(:id => ds.id) do |data|
                    parse_tag_string(ds.tags).each do |tag|
                      data.tag tag
                    end if ds.tags
                    data.current_value ds.current_value, :at => ds.updated.iso8601(6)
                    data.max_value ds.max_value if ds.max_value
                    data.min_value ds.min_value if ds.min_value
                    if ds.unit_symbol || ds.unit_type
                      units = {:type => ds.unit_type, :symbol => ds.unit_symbol}.delete_if_nil_value
                    end
                    data.unit ds.unit_label, units if !ds.unit_label.empty? || !units.empty?
                    data.datapoints do
                      ds.datapoints.each do |datapoint|
                        data.value(datapoint.value, "at" => datapoint.at.iso8601(6))
                      end
                    end if ds.datapoints.any?
                  end
                end if datastreams
              end
            end
          end
          builder.to_xml
        end

        # As used by http://cosm.com/api/v1/FEED_ID/datastreams/DATASTREAM_ID.xml
        def xml_5(options={})
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.eeml(_eeml_5) do |eeml|
              eeml.environment(:updated => updated.iso8601, :id => id, :creator => "http://www.haque.co.uk") do |environment|
                environment.title title unless title.blank?
                environment.feed "#{feed}.xml" unless feed.blank?
                environment.status status unless status.blank?
                environment.description description unless description.blank?
                environment.icon icon unless icon.blank?
                environment.website website unless website.blank?
                environment.email email unless email.blank?
                environment.location({:disposition => location_disposition, :exposure => location_exposure, :domain => location_domain}.delete_if_nil_value) do |location|
                  location.name location_name
                  location.lat location_lat
                  location.lon location_lon
                  location.ele location_ele
                end if location_disposition || location_exposure || location_domain || location_name || location_lat || location_lon || location_ele
                datastreams.each do |ds|
                  environment.data(:id => ds.id) do |data|
                    parse_tag_string(ds.tags).each do |tag|
                      data.tag tag
                    end if ds.tags
                    data.value ds.current_value, {:minValue => ds.min_value, :maxValue => ds.max_value}.delete_if_nil_value
                    if ds.unit_symbol || ds.unit_type
                      units = {:type => ds.unit_type, :symbol => ds.unit_symbol}.delete_if_nil_value
                    end
                    data.unit ds.unit_label, units if !ds.unit_label.empty? || !units.empty?
                  end
                end if datastreams
              end
            end
          end
          builder.to_xml
        end

      end
    end
  end
end

