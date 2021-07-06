FactoryBot.define do
  factory :member do
    first_name { Faker::Name.unique.first_name }
    last_name  { Faker::Name.unique.last_name }
    url        { Faker::Internet.url }

    after(:build) do |obj| 
      obj.class.skip_callback(:create, :after, :scrape_info, raise: false)
      obj.class.skip_callback(:save, :after, :shorten_url, raise: false)
    end
  end
end
