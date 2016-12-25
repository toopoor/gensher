module Voucher
  class Credit < Base
    AMOUNT = 500

    scope :next_active, -> { active }
  end
end