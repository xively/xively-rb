class Hash
  def delete_if_nil_value
    delete_if{|k,v| v.nil? || v.blank?}
  end

  def deep_stringify_keys
    inject({}) do |options, (key, value)|
      options[key.to_s] = (value.is_a?(Hash) ? value.deep_stringify_keys : value)
      options
    end
  end

  def deep_stringify_keys!
    self.replace(self.deep_stringify_keys)
  end
end
