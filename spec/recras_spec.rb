require "spec_helper"

describe Recras do
  it "has a version number" do
    expect(Recras::VERSION).not_to be nil
  end

	it "returns an error if credentials are false" do
		client = Recras::Client.new(username: 'beheer', password: 'fout')
		expect(client.valid).to be false
	end

	it "raises login required message" do
	  client = Recras::Client.new(username: 'beheer', password: 'fout')
	  expect{client.me}.to raise_error /Login Required/
	end


  context "authentication and default behaviour" do
	  
		before(:each) do
			@client = Recras::Client.new(username: 'beheer', password: 'demo')
		end

		it "returns information about 'me'" do
			result = @client.me
			expect(result).to be_kind_of Recras::Person
		end

		it "returns name 'Marthijn'" do
			result = @client.me
			expect(result.name).to eq "Marthijn Wolting"
		end

	  it "connects to the endpoint" do
	  end

	end
end
