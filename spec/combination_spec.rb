require "spec_helper"

# documentation: http://recras.github.io/docs/endpoints/arrangementen.html#get--api2-arrangementen
describe Recras::Combination do

	before(:all) do
		@client = Recras::Client.new(username: 'beheer', password: 'demo', host: 'https://demo.recras.nl')
		@combinations = @client.combinations
	end




	it "returns multiple combinations" do
		expect(@combinations).to be_kind_of Array
		# puts @combinations.last.inspect
		expect(@combinations.first).to be_kind_of Recras::Combination
	end

	it "returns name '0 Leeg'" do
		expect(@combinations.first.name).to eq "0 Leeg"
	end

	it "has a contact_form id" do
		# onlineboeking_contactformulier_id
		expect(@combinations.first.contact_form_id).to be > 0
	end

	it "has number of people" do
		result = @combinations.last
		expect(result.number_of_people).to be > 1
	end

	it "is allowed to pay later" do
		result = @combinations.last
		expect(result.allowed_to_pay_later).to be true
	end

	# context ".find" do
	# 	# it "finds a combination without login" do
  # 	# 	result = Recras::Combination.find(4)
	# 	# 	expect(result).to be_kind_of Recras::Combination
	# 	# end
	#
	# 	# it "has no products" do
	# 	#   result = Recras::Combination.find(4)
	# 	# 	expect(result.combination_items).to be_kind_of nil
	# 	# end
	# end

	context "#available_days" do

		xit "returns available_days without login" do
  		combination = Recras::Combination.find(4)
  		days = combination.available_days(number_of_people: 2)
			expect(days).to be_kind_of Array
		end

		it "returns an array" do
			days = @combinations.last.available_days(number_of_people: 2)
			expect(days).to be_kind_of Array
		end

		it "returns an error" do
		  expect {@combinations.last.available_days() }.to raise_error(/Insufficient details provided./)
		end
	end

	context "#available_times" do
		it "returns an array of times" do
			times = @combinations.last.available_times(number_of_people: 2, date: Time.now)
			expect(times).to be_kind_of Array
		end

		it "returns an error" do
		  expect {@combinations.last.available_times() }.to raise_error(/Date is required/)
		end
	end

	context "#contact_form", focus: true do
		it "has a contact form" do
			contact_form = @combinations.first.contact_form
			expect(contact_form).to be_kind_of Recras::ContactForm
		end
	end

	context "#book" do
		before(:all) do
			# get time
			@combination = @combinations.last
			times = @combination.available_times(number_of_people: 2, date: Time.now+(3600*48))
			@time = times.last
		end

		it "is allowed to pay later" do
		  expect(@combination.allowed_to_pay_later).to be true
		end

		it "creates a booking" do
			booking = @combination.book(date: @time, number_of_people: 2, contact_form_details: @combination.contact_form.default_values)
			expect(booking).to be_kind_of Recras::Booking
			# puts @combination.contact_form.default_values
			# puts booking.inspect
			expect(booking.status).to eq "reservering"
			expect(booking.message).to eq "Boeking gemaakt"
			expect(booking.customer_id).to be > 0
			expect(booking.payment_url).to be nil
		end
	end

	context "#find" do
		it "finds a specific combination (arrangment)" do
		  result = @client.combination(4)
		  expect(result).to be_kind_of Recras::Combination
		  expect(result.id).to eq 4
		end

		it "has iterneraries" do
		  result = @client.combination(4)
		  expect(result.itineraries).to be_kind_of Array
		end

		it "has iternerary description" do
		  result = @client.combination(4)
		  itinerary = result.itineraries.first
		  expect(itinerary).to be_kind_of Recras::Itinerary
		  puts itinerary.inspect
		  expect(itinerary.description).to match /.+/
		  expect(itinerary.duration_minutes).to be > 0
		  expect(itinerary.quantity).to be > 0
		  expect(itinerary.to_s).to match /\d+ persoon/i
		end

		it "has combiation_items" do
		  result = @client.combination(4)
		  expect(result.combination_items).to be_kind_of Array
		  expect(result.combination_items.first).to be_kind_of Recras::CombinationItem
		end

		it "returns not found error when invalid id is given" do
		  expect {@client.combination(20) }.to raise_error("Not Found")
		end
	end
end
