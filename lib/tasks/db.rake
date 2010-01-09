namespace :db do
  desc "Number of Item's in DB"
  task (:items => :environment) do
    p Item.count
  end
end
