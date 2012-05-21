[![Build Status](https://secure.travis-ci.org/cosm/cosm-rb.png)](http://travis-ci.org/cosm/cosm-rb)

Cosm gem
========================

WORK IN PROGRESS

This gem will convert between Cosm Data Formats.
You can use it to prepare data for sending to Cosm or for parsing data received from Cosm.

Allowed inputs
--------------

 * XML (EEML)
 * JSON
 * CSV

Outputs
-------

 * XML (EEML)
 * JSON
 * CSV

Cosm Interface
----------------------------

If you have your own model that maps to a Cosm Feed (such as an ActiveRecord model), this plugin will provide many convenience methods to convert your objects into Cosm objects.

### Example with ActiveRecord

    class Datastream < ActiveRecord::Base
      belongs_to :feed
    end

    class Feed < ActiveRecord::Base
      has_many :datastreams
      extend Cosm::Base
      is_cosm :feed
    end

### Provided methods
  
    @cosm_feed = feed.to_cosm # returns an instance of Cosm::Feed
    @cosm_feed.to_json(:version => "1.0.0") # converts your feed and associated datastreams into Cosm V2 JSON
    @cosm_feed.as_json(:version => "0.6-alpha") # provides a json hash for 0.6-alpha
    @cosm_feed.to_xml(:version => "0.5.1") # converts your feed and associated datastreams into Cosm V2 XML (EEML)

### Supported formats

 * JSON "1.0.0" - used by Cosm API v2
 * JSON "0.6-alpha" - used by Cosm API v1
 * XML "0.5.1" - used by Cosm API v2
 * XML "5" - used by Cosm API v1
 * CSV v1 - used by Cosm API v1
 * CSV v2 - used by Cosm API v2

### Mapped fields

See [the Cosm Api docs] [1] for a description of each field.

  [1]: https://cosm.com/docs/v2/ "Cosm Api Docs"

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
      extend Cosm::Base

      has_one :geo_location
      is_cosm :feed, {:location_lat => :geo_lat, :location_lon => :geo_lon}

      def geo_lat
        geo_location.try(:latitude)
      end

      def geo_lon
        geo_location.try(:longitude)
      end
    end

Examples using the Cosm objects
--------------------------------------------

    feed = Cosm::Feed.new('{"title":"Cosm Office Environment"}')
    feed.as_json # {"title" => "Cosm Office Environment"}
    feed.to_json # {"title":"Cosm Office Environment"}
    feed.to_xml
      #  <?xml version="1.0" encoding="UTF-8"?
      #  <eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
      #    <environment updated="2010-11-11T15:57:17.637887Z" id="12567" creator="https://cosm.com"> 
      #      <title>Cosm Office Environment</title>
      #    </environment>
      #  </eeml>
    feed.attributes # {:title => "Cosm Office Environment"}

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
    datastream = Cosm::Datastream.new(json)
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

    
