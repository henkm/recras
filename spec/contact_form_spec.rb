require "spec_helper"

# documentation: http://recras.github.io/docs/endpoints/arrangementen.html#get--api2-arrangementen
describe Recras::Combination do

	before(:all) do
		@client = Recras::Client.new(username: 'beheer', password: 'demo')
		@combinations = @client.combinations
		@combination = @combinations.first
	end
	
	context "#contact_form", focus: true do
		it "has a contact form" do
			contact_form = @combination.contact_form
			expect(contact_form).to be_kind_of Recras::ContactForm
		end

		it "has contact_form_fields" do
		  fields = @combination.contact_form.contact_form_fields
		  expect(fields).to be_kind_of Array
		end

	end

	context "#default_value" do
		before(:all) do
			@contact_form = @combination.contact_form
			@fields = @contact_form.contact_form_fields
		end

		it "has default name" do
		  field = @fields.first
		  expect(field.name).to eq "Groepsnaam"
		end

		it "returns a hash of default values" do
			result = @contact_form.default_values
			expect(result).to be_kind_of Hash
		end

		# @client = Recras::Client.new(username: 'beheer', password: 'demo')
		# @combinations = @client.combinations
		# fields = @combinations.first.contact_form.contact_form_fields

		# puts "Checking fields: \n#{fields.map(&:name)}"

		# for field in fields
		# 	if field.required
		# 		it "has a default value for required field #{field.name} of type #{field.field_identifier}" do
		# 			puts "Field: #{field.name}, #{field.field_identifier}, #{field.default_value}"
		# 		  expect(field.default_value).to be_present
		# 		end
		# 	end
		# end

	end

end
