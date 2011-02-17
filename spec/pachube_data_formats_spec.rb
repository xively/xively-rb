require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe PachubeDataFormats do
  it "should provide a template for Generator classes" do
    class TestGenerator
      extend PachubeDataFormats::Generator
    end
    lambda{TestGenerator.generate("")}.should raise_error(RuntimeError, "Implement self.generate(hash)")
  end

  it "should provide a template for Parser classes" do
    class TestParser
      extend PachubeDataFormats::Parser
    end
    lambda{TestParser.parse("")}.should raise_error(RuntimeError, "Implement self.parse(input)")
  end
end
