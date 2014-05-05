class Array
  def ^(other)
    unless other.is_a?(Array)
      error_message = "Invalid Type for '^' operator: #{other.class} received, expected Array"
      raise TypeError, error_message
    end

    union = self & other
    (self - union) | (other - union)
  end
end

