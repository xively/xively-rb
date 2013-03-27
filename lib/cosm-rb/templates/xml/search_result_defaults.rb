module Cosm
  module Templates
    module XML
      module SearchResultDefaults
        include XMLHeaders
        include Helpers

        def generate_xml(version)
          case version
          when "0.5.1"
            xml_0_5_1
          when "5"
            xml_5
          end
        end

        private

        # As used by http://cosm.com/api/v2/feeds.xml
        def xml_0_5_1
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.eeml(_eeml_0_5_1.merge({"xmlns:opensearch" => "http://a9.com/-/spec/opensearch/1.1/"})) do |eeml|
              eeml['opensearch'].totalResults totalResults
              eeml['opensearch'].startIndex startIndex
              eeml['opensearch'].itemsPerPage itemsPerPage
              results.each do |env|
                eeml.environment(:created => env.created.iso8601(6), :updated => env.updated.iso8601(6), :id => env.id, :creator => env.creator) do |environment|
                  environment.title env.title
                  environment.feed "#{env.feed}.xml"
                  environment.status env.status
                  environment.description env.description
                  environment.icon env.icon
                  environment.website env.website
                  environment.email env.email
                  environment.product_id env.product_id
                  environment.device_serial env.device_serial
                  environment.private_ env.private
                  parse_tag_string(env.tags).each do |tag|
                    environment.tag tag
                  end if env.tags
                  environment.location({:disposition => env.location_disposition, :exposure => env.location_exposure, :domain => env.location_domain}.delete_if_nil_value) do |location|
                    location.name env.location_name
                    location.lat env.location_lat
                    location.lon env.location_lon
                    location.ele env.location_ele
                  end if env.location_disposition || env.location_exposure || env.location_domain || env.location_name || env.location_lat || env.location_lon || env.location_ele
                  env.datastreams.each do |ds|
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
                  end if env.datastreams
                end
              end
            end
          end
          builder.to_xml
        end

        # As used by http://cosm.com/api/v1/feeds.xml
        def xml_5
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
            xml.eeml(_eeml_5.merge({"xmlns:opensearch" => "http://a9.com/-/spec/opensearch/1.1/"})) do |eeml|
              eeml['opensearch'].totalResults totalResults
              eeml['opensearch'].startIndex startIndex
              eeml['opensearch'].itemsPerPage itemsPerPage
              results.each do |env|
                eeml.environment(:updated => env.updated.iso8601, :id => env.id, :creator => "http://www.haque.co.uk") do |environment|
                  environment.title env.title
                  environment.feed "#{env.feed}.xml"
                  environment.status env.status
                  environment.description env.description
                  environment.icon env.icon
                  environment.website env.website
                  environment.email env.email
                  environment.location({:disposition => env.location_disposition, :exposure => env.location_exposure, :domain => env.location_domain}.delete_if_nil_value) do |location|
                    location.name env.location_name
                    location.lat env.location_lat
                    location.lon env.location_lon
                    location.ele env.location_ele
                  end
                  env.datastreams.each do |ds|
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
                  end if env.datastreams
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

