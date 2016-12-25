FactoryGirl.define do
  factory :activation_request do
    user nil
    admin nil
    system_deposit nil
    parent_deposit nil
    state "MyString"
  end
end
