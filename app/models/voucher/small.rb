module Voucher
  class Small < Base
    AMOUNT = 25

    scope :next_active, -> { active }
  end
end
