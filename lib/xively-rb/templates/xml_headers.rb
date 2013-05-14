module Xively
  module Templates
    module XMLHeaders

      private

      def _eeml_0_5_1
        {:xmlns => "http://www.eeml.org/xsd/0.5.1", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", :version => "0.5.1", "xsi:schemaLocation" => "http://www.eeml.org/xsd/0.5.1 http://www.eeml.org/xsd/0.5.1/0.5.1.xsd"}
      end

      def _eeml_5
        {:xmlns => "http://www.eeml.org/xsd/005", "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", :version => "5", "xsi:schemaLocation" => "http://www.eeml.org/xsd/005 http://www.eeml.org/xsd/005/005.xsd"}
      end

    end
  end
end
