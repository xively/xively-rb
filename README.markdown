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
 * Hash

Outputs
-------

 * XML (Pachube EEML)
 * JSON
 * CSV
 * Hash

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

