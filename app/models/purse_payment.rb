
module PursePayment
  TAB_TYPES = %w(all pending completed canceled systemic).freeze

  def self.model_name
    ActiveModel::Name.new(self, nil, 'PursePayment')
  end
end
