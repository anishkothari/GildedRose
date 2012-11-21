require './item.rb'

class GildedRose

  attr_reader :items

  ITEMS = {
    "+5 Dexterity Vest" => {:sell_in => 10, :quality => 20},
    "Aged Brie" => {:sell_in => 2, :quality => 0},
    "Elixir of the Mongoose" => {:sell_in => 5, :quality => 7},
    "Sulfuras, Hand of Ragnaros" => {:sell_in => 0, :quality => 80},
    "Backstage passes to a TAFKAL80ETC concert" => {:sell_in => 15, :quality => 20},
    "Conjured Mana Cake" => {:sell_in => 3, :quality => 6}
  }

  def initialize
    @items = []
    ITEMS.each do |item_name, item_attributes|
      @items << Item.new(item_name, item_attributes[:sell_in], item_attributes[:quality])
    end
  end
  
  def strategy_for(item)
	if item.name == "Aged Brie"
		aged_brie = AgedBrieStrategy.new(item)
	elsif item.name == "Backstage passes to a TAFKAL80ETC concert"
		backstage_passes = BackstagePassStrategy.new(item)
	elsif item.name == "Conjured Mana Cake"
		conjured = ConjuredStrategy.new(item)
	else
		normal = NormalStrategy.new(item)
	end
  end

  def update_quality
	non_legendary_items.each do |item|
	strategy = strategy_for(item)
	strategy.update(item) if strategy
	item.sell_in -= 1
    end
  end

  def non_legendary_items
    @items.select do |item|
      item.name != "Sulfuras, Hand of Ragnaros"
    end
  end
end

class NormalStrategy

	def initialize(item)
	end

	def update(item)
		item.quality -= 1
		item.quality -= 1 if item.sell_in <= 0
		item.quality = 0 if item.quality < 0
	end

end

class AgedBrieStrategy

	def initialize(item)
	end
	
	def update(item)
        item.quality += 1
		item.quality = 50 if item.quality > 50
	end

end

class BackstagePassStrategy

	def initialize(item)
	end
	
	def update(item)
		if item.sell_in <= 0
			item.quality = 0 
		elsif item.sell_in > 10
			item.quality += 1
		elsif item.sell_in > 5
			item.quality += 2
		elsif item.sell_in <= 5
			item.quality += 3
		end
	end

end

class ConjuredStrategy

	def initialize(item)
	end
	
	def update(item)
		item.quality -= 2
		item.quality -= 1 if item.sell_in < 0
		item.quality = 0 if item.quality < 0
	end
	
end
