module Cosm
  module Parsers
    module XML
      module Helpers

        private

        def strip(value)
          return value.nil? ? nil : value.strip
        end

        def convert_to_hash(val)
          if val.class == String
            {'__content__' => val}
          else
            val || {}
          end
        end

        def convert_to_array(val)
          if val.is_a?(Hash)
            val = [val]
          else
            val
          end
        end

        def _extract_datastreams(xml)
          return unless xml
          xml = convert_to_array(xml)
          xml.collect do |ds|
            _extract_datastream(ds)
          end
        end


        def _extract_datastream(xml)
          current_value = convert_to_hash(xml['current_value'])
          unit = convert_to_hash(xml['unit'])
          {
            :current_value => strip(current_value['__content__']),
            :updated => strip(current_value['at']),
            :id => strip(xml['id']),
            :unit_symbol => strip(unit['symbol']),
            :unit_type => strip(unit['type']),
            :unit_label => strip(unit['__content__']),
            :min_value => strip(xml['min_value']),
            :max_value => strip(xml['max_value']),
            :datapoints => _extract_datapoints(xml['datapoints'])
          }.merge(sanitised_tags(xml))
        end

        def _extract_datastreams_v1(xml)
          return unless xml
          xml = convert_to_array(xml)
          xml.collect do |ds|
            _extract_datastream_v1(ds)
          end
        end

        def _extract_datastream_v1(xml)
          unit = convert_to_hash(xml['unit'])
          value = convert_to_hash(xml['value'])
          {
            :current_value => strip(value['__content__']),
            :id => strip(xml['id']),
            :unit_symbol => strip(unit['symbol']),
            :unit_type => strip(unit['type']),
            :unit_label => strip(unit['__content__']),
            :min_value => strip(value['minValue']),
            :max_value => strip(value['maxValue'])
          }.merge(sanitised_tags(xml))
        end

        def _extract_datapoints(xml)
          return unless xml
          value = xml['value']
          value = convert_to_array(value)
          value.collect do |dp|
            _extract_datapoint(dp)
          end
        end

        def _extract_datapoint(xml)
          value = convert_to_hash(xml['value'])
          {
            :at => strip(value['at']),
            :value => strip(value['__content__'])
          }
        end

        def _extract_tags(xml)
          if xml.class != Array
            xml = [xml]
          end
          if (tags = xml.collect { |t| "#{t}".strip }).any?
            Cosm::CSV.generate_line(tags.delete_if { |v| v.to_s.strip == "" }.sort{ |a,b| a.downcase <=> b.downcase}).strip
          end
        end

        # Keep blank tags but delete if value is nil
        def sanitised_tags(xml)
          if xml.key?('tag')
            {:tags => _extract_tags(xml['tag'])}
          else
            {}
          end
        end
      end
    end
  end
end
