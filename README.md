# Recras

The Recras gem is a straight forward ruby binder for the Recras API V2. This gem covers a great portion of the native API functionality, but certainly not a 100%. Feel free to fork this project and make adjustments.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'recras'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install recras

## Usage

To request two barcodes from two different ticket kinds (4 barcodes in total), you can do the following:

### Setup
```ruby
# Setup the Recras client with credentials
@recras_client = Recras::Client.new(username: 'beheer', password: 'demo')

# Check the credentials first
@recras_client.valid? #returns true or false

# Get details about current user
@recras_client.me # => #<Recras::Person:0x007fca5492ddf0 @id=1, @name="Joe Sixpack, @address="Street 1", @postal_code="1234 AB", @city="Amsterdam", @country_code="", @company_id=1, @phone="", @email="test@example.org">

```

### Combinations
The Recras system bundles different products together in 'combinations'. Their API uses the term 'arrangementen' for it.

A combination has a number of fields. __Not all the fields present in the native API are implemented. Feel free to add those and issue a pull request.__

- id
- name
- visible_online
- number_of_people
- allowed_to_pay_later
- combination_items
- contact_form_id
- itineraries (returns a list of `<Recras::Itinerary>` objects)
- client (returns the client object that made the request)


```ruby
# List the clients combinations
@recras_client.combinations # => returns an array of <Recras::Combination> objects

# Find a single combination:
@combination = @recras_client.combination(4) => <Recras::Combination:0x007fc617cd1948 @id=4 ...>

# Show the itineraries
for itinerary in @combination.itineraries
	puts itenerary
end
# outputs:
# Ontvangst met koffie - 10 personen (00:30:00)
# Leer boogschieten - 10 personen (02:15:00)
```

### CombinationItem
Each combination has multiple combination_items. In the native API these are called 'arrangementregels'. When checking availability or making a reservation, you always have to enter both the combination **and** the individual combination_items+number_of_people.

Attributes:
- id
- location_id
- begins_at (ISO 8601 Date Time format)
- ends_at (ISO 8601 Date Time format)
- description
- number_of_people 
- product_id

```ruby
# You can find the combination_items only through a combination:
@combination = @recras_client.combinations.last
@combination_items = @combination.combination_items # => Array of <Recras::CombinationItem> objects
```

### Checking availability
Checking the availability is always a two-steps process: 
1. Check the available days for chosen combination
2. Fetch the available times for chosen day

The `@combination.available_days` method takes several arguments:

```ruby
available_days(items: [], number_of_people: nil, from_time: Date.today, until_time: (Time.now + 3600*24*7))
```

- `items:` array of hashes. Example: `[{combination_item_id: 2, number_of_people: 1}, {combination_item_id: 5, number_of_people: 4}]`
- `number_of_people:` an integer greater than 0.
- `from_time` Start of date range
- `until_time` End of date range

__Important:__ If you don't supply the `items` argument, you have to enter a `number_of_people`. This gem than makes the assumption that you want each item in this combination to be chosen the same amount of times.
#### Checking available days
```ruby
@combination.available_days(number_of_people: 2) #=> ["2017-04-11", "2017-04-12", "2017-04-13", "2017-04-14", "2017-04-15", "2017-04-17", "2017-04-18"]

```

#### Checking available times
```ruby
@combination.available_times(number_of_people: 2, date: "2018-04-11") #=> ["2017-04-14T11:00:00+02:00", "2017-04-14T11:30:00+02:00", "2017-04-14T12:00:00+02:00", "2017-04-14T12:30:00+02:00", "2017-04-14T13:00:00+02:00", "2017-04-14T13:30:00+02:00"]

```

### ContactForm
If you see the checkout page of any of Recras' clients, you'll notice that the consumer has to fill in a couple of fields in the last step before the booking. These fields are specific to the selected Combination (arrangement). To know which fields to show, how to label them and with which identifier to submit them, you use the `@combination.contact_form`. In it are `<Recras::ContactFormField>` objects.

A ContactFormField has the following attributes:
- id
- name
- contact_form_id
- input_type
- required
- options
- special_for_booking (if true, it will be displayed as information on the ticket/booking confirmation)
- field_identifier
- contact_form (parent object)




### Make a booking
Making a booking is not much different from checking times: you need to know when the consumer wants to book and wich items+quantity. It looks like this:
__Please note:__ in the example below, we assume that the consumer want to book 2 units of every CombinationItem in given combination.
```ruby
contact_form_details: {
	"contact.naam"=>"", 
    "contactpersoon.voornaam"=>"Voornaam", 
    "contactpersoon.achternaam"=>"Achternaam", 
    "contactpersoon.email1"=>"test@example.org", 
    "contactpersoon.telefoon1"=>"", 
    "contactpersoon.adres"=>"", 
    "contactpersoon.postcode"=>"", 
    "contactpersoon.plaats"=>"", 
    "veel_tekst_0"=>""
}

@combination.book(number_of_people: 2, date: "2017-04-14T13:00:00+02:00", contact_form_details: contact_form_details) 
# => #<Recras::Booking:0x007f99bab94c30 @id=8994, @status="reservering", @message="Boeking gemaakt", @customer_id=8986>
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/henkm/wheretocard.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Credits and disclaimer

This gem is made with love by the smart people at [Eskes Media B.V.](http://www.eskesmedia.nl) and [dagjewegtickets.nl](https://www.dagjewegtickets.nl) 
Recras is not involved with this project and has no affiliation with Eskes Media B.V. No rights can be derrived from using this gem.
