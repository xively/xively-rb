module Xively
  module Helpers
    def parse_tag_string(string)
      return [] if string.blank?
      string = string.join(',') if string.is_a?(Array)
      tags = []
      quoted_mode = false
      tags << string.chars.reduce("") do |buffer, char|
        if char == ','
          if !quoted_mode
            tags << buffer
            buffer = ""
          else
            buffer << char
          end
        elsif char == '"'
          if buffer.length > 0 && buffer[-1,1] == '\\'
            buffer[-1] = char
          else
            quoted_mode = !quoted_mode
            buffer << char
          end
        else
          buffer << char
        end
        buffer
      end
      # strip the tags
      tags.map { |t|
        /\A\s*("(.*)"|(.*))\s*\Z/.match(t)
        $2 || $3.strip
      }.sort{|a,b| a.downcase <=> b.downcase}
    end

    def join_tags(tags)
      return tags unless tags.is_a?(Array)
      tags.sort{|a,b| a.downcase <=> b.downcase}.join(',')
    end
  end
end

