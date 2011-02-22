Pachube Data Formats gem
========================

WORK IN PROGRESS

This gem will convert between Pachube Data Formats.
You can use it to prepare data for sending to Pachube or for parsing data received from Pachube.

Allowed inputs
--------------

 * XML (Pachube EEML) - Not Yet Implemented
 * JSON
 * CSV - Not Yet Implemented
 * Hash

Outputs
-------

 * XML (Pachube EEML) - Not Yet Implemented
 * JSON - Version 2 JSON
 * CSV - Not Yet Implemented
 * Hash

ActiveRecord support
--------------------

If you have a ActiveRecord structure that maps to a Pachube Feed, this plugin will provide many convenience methods.
Currently it will only work at Feed level and implements a Pachube API V2 JSON formatter.
Attribute to Pachube field mapping in progress.

    class Datastream < ActiveRecord::Base
      belongs_to :feed
    end

    class Feed < ActiveRecord::Base
      has_many :datastreams
      is_pachube_data_format :feed
    end

    feed.to_pachube_json # converts your feed and associated datastreams into Pachube V2 JSON

Examples
--------

    feed = PachubeDataFormats::Feed.new('{"title":"Pachube Office Environment"}')
    feed.to_json # {"title":"Pachube Office Environment"}
    feed.to_xml
      #  <?xml version="1.0" encoding="UTF-8"?
      #  <eeml xmlns="http://www.eeml.org/xsd/0.5.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="0.5.1" xsi:schemaLocation="http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"> 
      #    <environment updated="2010-11-11T15:57:17.637887Z" id="12567" creator="http://www.pachube.com"> 
      #      <title>Pachube Office Environment</title>
      #    </environment>
      #  </eeml>
    feed.to_hash # {:title => "Pachube Office Environment"}

