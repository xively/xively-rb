require 'spec_helper'

describe PachubeDataFormats::App do
  it "should have a constant that defines the allowed keys" do
    PachubeDataFormats::App::ALLOWED_KEYS.sort.should == %w(id name description app_id secret redirect_uri contact_email published tags creator_login updated).sort
  end

  context "validation" do
    before(:each) do
      @app = PachubeDataFormats::App.new
    end

    it "should require a name field" do
      @app.name = nil
      @app.should_not be_valid
      @app.errors[:name].should include("can't be blank")
    end

    it "should always return a boolean from the published? accessor, even if attribute nil" do
      @app.published.should be_nil
      @app.published?.should be_false
    end
  end
end
