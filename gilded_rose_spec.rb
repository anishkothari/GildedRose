require './gilded_rose.rb'
require "rspec"

describe GildedRose do

  VEST = "+5 Dexterity Vest"
  ELIXIR = "Elixir of the Mongoose"
  BRIE = "Aged Brie"
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert"
  CONJURED_CAKE = "Conjured Mana Cake"

  let(:gilded_rose) {GildedRose.new}
  let(:vest) {item_by_name(VEST)}
  let(:elixir) {item_by_name(ELIXIR)}
  let(:brie) {item_by_name(BRIE)}
  let(:sulfuras) {item_by_name(SULFURAS)}
  let(:passes) {item_by_name(BACKSTAGE_PASSES)}
  let(:conjured) {item_by_name(CONJURED_CAKE)}

  def item_by_name(name)
    gilded_rose.items.find {|item| item.name == name}
  end

  def update_quality(n = 1)
    n.times { gilded_rose.update_quality }
  end

  context "sell_in values" do
    it "decreases by 1 for non-legendary items" do
      update_quality

      vest.sell_in.should == 9
      brie.sell_in.should == 1
      elixir.sell_in.should == 4
      passes.sell_in.should == 14
      conjured.sell_in.should == 2
      sulfuras.sell_in.should == 0
    end

    it "stays constant for legendary items" do
      update_quality
      sulfuras.sell_in.should == 0

      update_quality
      sulfuras.sell_in.should == 0
    end
  end

  context "quality values" do
    context "normal items" do
      it "decreases the quality of an item when updating quality" do
        update_quality
        vest.quality.should == 19
      end

      it "quality degrades twice as fast once sell in date passes" do
        update_quality(10)
        vest.quality.should == 10

        update_quality
        vest.quality.should == 8
      end

      it "the quality should never be lower than 0" do
        update_quality(6)
        elixir.quality.should == 0

        update_quality
        elixir.quality.should == 0
      end
    end

    context "aged brie" do
      it "increases in quality when it ages" do
        update_quality
        brie.quality.should == 1
      end

      it "does not exceed 50 in quality" do
        update_quality(50)
        brie.quality.should == 50
      end
    end

    context "Sulfuras" do
      it "should never decrease in quality" do
        update_quality
        sulfuras.quality.should == 80
      end
    end

    context "backstage passes" do
      it "increases in quality by 1 with more than 10 days to sell" do
        update_quality(5)
        passes.quality.should == 25
      end

      it "increases in quality by 2 with more than 5 days to sell" do
        update_quality(10)
        passes.quality.should == 35
      end

      it "increases by 3 with less than 5 days to sell until expired" do
        update_quality(15)
        passes.quality.should == 50
      end

      it "quality drops to 0 when it expires" do
        update_quality(16)
        passes.quality.should == 0
      end
    end

    context "conjured items" do
      it "quality decreases twice as fast as other items" do
        update_quality
        conjured.quality.should == 4
      end
    end
    
    context "legendary items" do
		it "has no sell_in date" do
			update_quality
			sulfuras.sell_in.should == 0
		end
    end
  end
end
