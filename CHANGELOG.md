# Changelog

## 0.1.10
 * Adding label field to Keys
 * should pass options through to Key#as_json
 * Clearing up some confusion with trigger/key parsers
 * Improving the Key.to_json error handling

## 0.1.09
 * Adding Key model for api keys, XML/JSON parsers, and JSON template

## 0.1.08
 * Rewrote tag string parser

## 0.1.07
 * Adding some validations on feed_id for datastreams and datapoints

## 0.1.06
 * Feeds should invalidate with duplicate datastream ids or invalid datastreams
 * Fixed a bug in Template#method_missing

## 0.1.05
 * Added CSV feed parsing with autodetection of version

## 0.1.04
 * Added user node parsers to Feed eeml 0.5.1 and json 1.0.0

## 0.1.03
 * Added owner_login and owner_user_level to Feed
 * user node added to json 1.0.0 and eeml 0.5.1 templates for Feed

## 0.1.02
 * Bug fix release
 * Handling empty (nil) datastreams in json 1.0.0 (feeds and search results)

## 0.1.01
 * Major release that 
 * Eliminates requirement for ActiveSupport / ActiveModel
 * PachubeDataFormat objects have basic validation

## 0.0.3
 * Ignore nil tags with json parsers
 * Added templates for datastream level eeml 005 and 0.5.1
 * Added templates for EEML 005 and 0.5.1 (v1 / v2)
 * Eeml 0.5.1 and 5 datastream parser
 * Eeml 0.5.1 and 5 feed parser
 * Providing as_pachube_xml on AR records
 * Adding creator to default xml parsers
 * encode xml in utf-8
 * Adding feed_id and feed_creator onto datastream (used by xml)
 * Creator is always http://www.haque.co.uk in v1 xml
 * Creator always http://www.haque.co.uk in v1 templates
 * First pass at a Datapoint model w/ parsers and templates
 * Added datapoints to json parser
 * Creating datapoint templates
 * Templates append format onto feed url
 * order of xml attributes
 * Hash#delete_if_nil_value
 * Completely ignore unit nodes in xml if no unit attributes present
 * iso8601 shouldn't be to precision of v2 api     ignore nil.iso8601 calls
 * Allow excluding datastreams
 * Hooking up datapoints into ActiveRecord
 * Bug fix: Datapoint json template wasn't formatting time to iso8601(6)
 * datapoint templates need no version as there is only one
 * moving private node
 * Hide min/max value nodes on eeml 0.5.1 templates
 * Simplifying ActiveRecord hooks     Updated documentation
 * Datapoint templates should iso8601 at     Feed json template datapoints in iso8601(6)
 * Added json template for search results
 * XML and JSON templates for search results
 * Adding opensearch namespace and nodes
 * Merge branch 'hotfix-0.0.2' into develop
 * Incorporating hotfix changes into search results
 * Restructure of lib
 * Basic csv for datapoints (full and minimal)
 * Basic csv for datastreams and feeds      * V1      * V2      * V2 full
 * Allows options to be passed to to_csv
 * KICK: Keep it consistent knucklehead
 * Datastream#to_csv shows datapoints      * options[:both] will include datastream as first element      * Will only show datastream if no datapoints      * Will only show all datapoints if any
 * Escaping csv cells properly
 * Handling datapoints in feed#to_csv
 * Adding depth option to datapoint#to_csv
 * Adding depth option to datastream#to_csv
 * Ignoring units in eeml if no attributes present
 * Refactoring specs
 * Handle empty tags in xml
 * Ignore primary nodes in xml feed templates

