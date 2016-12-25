module Voucher
  # PUBLIC_TYPES = %w(credit half five)
  TAB_TYPES = %w(all pending activated completed)
  PUBLIC_TYPES = %w(small)
  PUBLIC_ATTRS = [:created_at, :state]

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Voucher')
  end

  def self.class_type(type)
    case type
      when 'credit'
        Credit
      when 'half'
        HalfSegment
      when 'five'
        FiveSegment
      when 'small'
        Small
      else
    end
  end
end
