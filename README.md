Pachube Data Formats gem
========================

WORK IN PROGRESS

This gem will convert between Pachube Data Formats.
You can use it to prepare data for sending to Pachube or for parsing data received from Pachube.

Allowed inputs
--------------

 * XML (Pachube EEML)
 * JSON
 * CSV

Outputs
-------

 * XML (Pachube EEML)
 * JSON
 * CSV

PachubeDataFormats Interface
----------------------------

If you have your own model that maps to a Pachube Feed (such as an ActiveRecord model), this plugin will provide many convenience methods to convert your objects into Pachube objects.

### Example with ActiveRecord

    class Datastream < ActiveRecord::Base
      belongs_to :feed
    end

    class Feed < ActiveRecord::Base
      has_many :datastreams
      extend PachubeDataFormats::Base
      is_pachube_data_format :feed
    end

### Provided methods
  
    @pachube_feed = feed.to_pachube # returns an instance of PachubeDataFormats::Feed
    @pachube_feed.to_json(:version => "1.0.0") # converts your feed and associated datastreams into Pachube V2 JSON
    @pachube_feed.as_json(:version => "0.6-alpha") # provides a json hash for 0.6-alpha
    @pachube_feed.to_xml(:version => "0.5.1") # converts your feed and associated datastreams into Pachube V2 XML (EEML)

### Supported formats

 * JSON "1.0.0" - used by Pachube API v2
 * JSON "0.6-alpha" - used by Pachube API v1
 * XML "0.5.1" - used by Pachube API v2
 * XML "5" - used by Pachube API v1
 * CSV v1 - used by Pachube API v1
 * CSV v2 - used by Pachube API v2

### Mapped fields

See [the Pachube Api docs] [1] for a description of each field.

  [1]: http://api.pachube.com/v2/#data-structure "Pachube Api Docs"

By default the gem expects your object to have the following fields:

#### Feeds

 * creator
 * datastreams
 * description
 * email
 * feed
 * icon
 * id
 * location_disposition
 * location_domain
 * location_ele
 * location_exposure
 * location_lat
 * location_lon
 * location_name
 * private
 * status
 * tags
 * title
 * updated
 * website


#### Datastreams

 * current_value
 * datapoints
 * feed_creator
 * feed_id
 * id
 * max_value
 * min_value
 * tags
 * unit_label
 * unit_symbol
 * unit_type
 * updated
 
#### Datapoints

 * at
 * value
 * feed_id
 * datastream_id

If you use different field names, want to map custom fields or want to map fields onto instance methods you can:

    class Feed < ActiveRecord::Base
      extend PachubeDataFormats::Base

      has_one :geo_location
      is_pachube_data_format :feed, {:location_lat => :geo_lat, :location_lon => :geo_lon}

      def geo_lat
        geo_location.try(:latitude)
      end

      def geo_lon
        geo_location.try(:longitude)
      end
    end

Examples using the PachubeDataFormat objects
--------------------------------------------

    feed = PachubeDataFormats::Feed.new('{"title":"Pachube Office Environment"}')
    feed.as_json # {"title" => "Pachube Office Environment"}
    feed.to_json # {"title":"Pachube Office Environment"}
    feed.to_xml
      #  <?xml version="1.0" encoding="UTF-8"?
      #  <eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
      #    <environment updated="2010-11-11T15:57:17.637887Z" id="12567" creator="http://www.pachube.com"> 
      #      <title>Pachube Office Environment</title>
      #    </environment>
      #  </eeml>
    feed.attributes # {:title => "Pachube Office Environment"}

### Parsing a Datastream using json

    json = '
      {
          "max_value": "658.0",
          "current_value": "14",
          "datapoints": [{
              "value": "1",
              "at": "2011-03-02T15:59:56.895922Z"
          },
          {
              "value": "1",
              "at": "2011-03-02T16:00:07.188648Z"
          },
          {
              "value": "2",
              "at": "2011-03-02T16:00:18.416500Z"
          }],
          "min_value": "0.0",
          "id": "0",
          "tags": ["humidity", "Temperature", "freakin lasers"],
          "version": "1.0.0",
          "unit": {
              "label": "percentage",
              "symbol": "%",
              "type": "derived SI"
          },
          "at": "2011-02-16T16:21:01.834174Z"
      }'
    datastream = PachubeDataFormats::Datastream.new(json)
    datastream.to_xml # =>
    # <?xml version="1.0" encoding="UTF-8"?>
    # <eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd">
    #   <environment creator="" updated="2011-02-16T16:21:01.834174Z" id="">
    #     <data id="0">
    #       <tag>freakin lasers</tag>
    #       <tag>humidity</tag>
    #       <tag>Temperature</tag>
    #       <current_value at="2011-02-16T16:21:01.834174Z">14</current_value>
    #       <max_value>658.0</max_value>
    #       <min_value>0.0</min_value>
    #       <unit type="derived SI" symbol="%">percentage</unit>
    #       <datapoints>
    #         <value at="2011-03-02T15:59:56.895922Z">1</value>
    #         <value at="2011-03-02T16:00:07.188648Z">1</value>
    #         <value at="2011-03-02T16:00:18.416500Z">2</value>
    #       </datapoints>
    #     </data>
    #   </environment>
    # </eeml>

    
