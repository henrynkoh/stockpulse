FactoryBot.define do
  factory :stock do
    ticker { "MyString" }
    sector { "MyString" }
    price { 1.5 }
    volume { 1 }
    rsi { 1.5 }
    short_volume { 1.5 }
    short_percent { 1.5 }
    sentiment { "MyString" }
    signal { "MyString" }
    news_url { "MyString" }
  end
end
