require "spec_helper"

# documentation: http://recras.github.io/docs/endpoints/arrangementen.html#get--api2-arrangementen
describe Recras::CombinationItem do

	before(:all) do
		@client = Recras::Client.new(username: 'beheer', password: 'demo')
		@combinations = @client.combinations
		@combination = @combinations.last
	end

	
	it "has multiple combination items" do
		expect(@combination.combination_items).to be_kind_of Array
		expect(@combination.combination_items.first).to be_kind_of Recras::CombinationItem
	end

	it "parses begin_time" do
	  expect(@combination.combination_items.first.begins_at).to be_kind_of Time
	end

end
