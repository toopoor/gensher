FactoryGirl.define do
  factory :voucher_request do
    owner nil
    user nil
    voucher nil
    state "MyString"
    activated_at "2016-10-20 13:37:30"
    completed_at "2016-10-20 13:37:30"
  end
end
