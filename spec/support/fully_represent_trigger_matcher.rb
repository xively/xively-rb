RSpec::Matchers.define :fully_represent_trigger do |format, formatted_trigger|
  match do |trigger|
    if format.to_sym == :xml
      match_xml_trigger(trigger, formatted_trigger)
    end
  end

  failure_message_for_should do |trigger|
    "expected #{trigger} to fully represent #{formatted_trigger}"
  end

  description do
    "expected #{formatted_datapoint.class} to be fully represented"
  end

  def match_xml_trigger(trigger, formatted_trigger)
    xml = Nokogiri.parse(formatted_trigger)
    trigger.id.should == xml.at_xpath("//id").content
    trigger.url.should == xml.at_xpath("//url").content
    trigger.trigger_type.should == xml.at_xpath("//trigger-type").content
    trigger.threshold_value.should == xml.at_xpath("//threshold-value").content
    trigger.notified_at.should == xml.at_xpath("//notified-at").content
    trigger.user.should == xml.at_xpath("//user").content
    trigger.environment_id.should == xml.at_xpath("//environment-id").content
    trigger.stream_id.should == xml.at_xpath("//stream-id").content
  end
end


