module PachubeDataFormats
  class Template
    attr_accessor :subject
    attr_accessor :presentation
    attr_accessor :output

    undef_method :id

    def initialize(subject, presentation, &block)
      @subject = subject
      @presentation = presentation
      @output = {}
    end

    def method_missing(sym, *args, &block)
      if block_given?
        @output[sym] = @subject.instance_eval &block
      else
        @output[sym] = @subject.send(sym)
      end
    end

    def output!
      @output.reject {|k,v| v.nil?}
    end
  end
end

