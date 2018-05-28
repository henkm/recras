require "spec_helper"

describe Recras do
  it "has a version number" do
    expect(Recras::VERSION).not_to be nil
  end

	it "returns an error if credentials are false" do
		client = Recras::Client.new(host: 'https://demo.recras.nl', username: 'beheer', password: 'fout')
		expect(client.valid).to be false
	end

	it "raises login required message" do
	  client = Recras::Client.new(host: 'https://demo.recras.nl', username: 'beheer', password: 'fout')
	  expect{client.me}.to raise_error /Login Required/
	end


  context "authentication and default behaviour" do

		before(:each) do
			@client = Recras::Client.new(host: 'https://demo.recras.nl', username: 'beheer', password: 'demo')
		end

		it "returns information about 'me'" do
			result = @client.me
			expect(result).to be_kind_of Recras::Person
		end

		it "returns name 'Marthijn'" do
			result = @client.me
			expect(result.name).to eq "Marthijn"
		end

		it 'returns a list of payment methods' do
			result = @client.payment_methods
			expect(result).to be_an Array
			# result.each{|item| puts item.inspect }
			expect(result.first).to be_a Recras::PaymentMethod
		end

	  it "connects to the endpoint" do
	  end

	end
end
