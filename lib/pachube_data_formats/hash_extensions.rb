class Hash
  def delete_if_nil_value
    delete_if{|k,v| v.nil? || v.blank?}
  end
end
