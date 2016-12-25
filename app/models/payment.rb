module Payment
  TAB_TYPES = %w(all pending completed canceled)

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Payment')
  end
end