require 'levenshtein'

module CustomValidations
  def validates_no_duplicates(attr_name)
    puts "ATTR NAME:"+attr_name.to_s
    puts "Items length #{Item.find(:all).length}"
    Item.find(:all).each do |current_item|
      puts "HERE"
      puts "Levenshtein distance: #{Levenshtein.distance(current_item.title.downcase, self.eval(attr_name.to_s))}"
      if Levenshtein.distance(current_item.title.downcase, item_title) <3
        errors.add "Duplicated title exists."
        break
      end
    end
  end
end
ActiveRecord::Base.extend(CustomValidations)