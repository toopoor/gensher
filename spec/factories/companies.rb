FactoryGirl.define do
  factory :company do
    user nil
    name "MyString"
    logo "MyString"
    description "MyText"
    video_url "MyString"
    marketing "MyText"
    rating 1
    moderated false
  end
end
