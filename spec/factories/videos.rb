FactoryBot.define do
  factory :video do
    stock { nil }
    script { "MyText" }
    video_path { "MyString" }
    thumbnail_path { "MyString" }
    youtube_id { "MyString" }
    status { "MyString" }
  end
end
