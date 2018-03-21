module Recras

  # links to 'arrangementen' in the API
  # http://recras.github.io/docs/endpoints/arrangementen.html
  class Combination
    extend Recras
    # @note The is a required parameter.

    attr_accessor :id
    attr_accessor :name
    attr_accessor :visible_online
    attr_accessor :number_of_people
    attr_accessor :allowed_to_pay_later
    attr_accessor :combination_items
    attr_accessor :itineraries
    attr_accessor :price_per_person_incl_vat
    attr_accessor :price_total_incl_vat
    attr_accessor :contact_form_id
    attr_accessor :client

    # Initializer to transform a +Hash+ into an Combination object
    # @param [Hash] args
    def initialize(args=nil)
      required_args = []
      for arg in required_args
        if args.nil? || args[arg].nil?
          raise RecrasError.new(self), "Insufficient login credentials. Please provide @username, @password"
        end
      end

      return if args.nil?
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end



    # returns a Recras::ContactForm
    def contact_form
      json = client.make_request("contactformulieren/#{contact_form_id}")
      cf = Recras.parse_json(json: json, endpoint: "contactformulier", client: client)
      return cf
    end



    # returns a list of available days (in string format) for a given campaign
    # exampel: combination.available_days(combination_items: [{combination_item_id: 1, number_of_people: 2}])
    # If no combination_items are given, assume that you want each item to be booked. In that scenario,
    # also use the 'number_of_people' argument. E.g.: @combination.available_days(number_of_people: 2).
    def available_days(items: [], number_of_people: nil, from_time: Date.today, until_time: (Time.now + 3600*24*7))
      product_items = convert_items(items, number_of_people)

      if product_items && product_items.any?
        body_data = {
            arrangement_id: id,
            producten: product_items,
            begin: from_time.strftime("%Y-%m-%d"),
            eind: until_time.strftime("%Y-%m-%d")
        }
      elsif number_of_people
        body_data = {
            arrangement_id: id,
            begin: from_time.strftime("%Y-%m-%d"),
            eind: until_time.strftime("%Y-%m-%d")
        }
      else
        raise RecrasError.new(self), "Insufficient details provided. Either combination_items or number_of_people are required."
      end

      # make request
      json = client.make_request("onlineboeking/beschikbaredagen", body: body_data.to_json, http_method: :post)

      if json.is_a?(Hash) && json["error"]
        raise RecrasError.new(self), json["error"]["message"]
      else
        return json
      end

    end


    # returns a list of available days (in string format) for a given campaign
    # exampel: combination.available_days(combination_items: [{combination_item_id: 1, number_of_people: 2}])
    # If no combination_items are given, assume that you want each item to be booked. In that scenario,
    # also use the 'number_of_people' argument. E.g.: @combination.available_days(number_of_people: 2).
    def available_times(items: [], number_of_people: nil, date: nil)
      product_items = convert_items(items, number_of_people)

      # convert date
      date = convert_date(date)

      if product_items.any?
        body_data = { arrangement_id: id, producten: product_items, datum: date }
        json = client.make_request("onlineboeking/beschikbaretijden", body: body_data.to_json, http_method: :post)

        if json.is_a?(Hash) && json["error"]
          raise RecrasError.new(self), json["error"]["message"]
        else
          return json
        end
      else
        raise RecrasError.new(self), "Insufficient details provided. Either combination_items or number_of_people are required."
      end
    end


    # make a reservation for this combination
    def book(items: [], number_of_people: nil, date: nil, payment_method: "factuur", contact_form_details: {})

      product_items = convert_items(items, number_of_people)
      date = convert_date(date)

      if product_items.any?
        body_data = {
          arrangement_id: id,
          producten: product_items,
          begin: date,
          betaalmethode: payment_method,
          contactformulier: contact_form_details
        }
        json = client.make_request("onlineboeking/reserveer", body: body_data.to_json, http_method: :post)

        if json.is_a?(Hash) && json["error"]
          raise RecrasError.new(self), json["error"]["message"]
        else
          booking = Recras.parse_json(json: json, endpoint: "booking")
          return booking
        end
      else
        raise RecrasError.new(self), "Insufficient details provided. Either combination_items or number_of_people are required."
      end

    end
    alias_method :make_booking, :book

    # returns an array of combination_items
    # def combination_items
    #   result = make_request("arrangementen")
    #   a = []
    #   for json in result
    #     a << Recras.parse_json(json: json, endpoint: "arrangementen")
    #   end
    #   return a
    # end

    # translates the mapping between the Recras API
    # and the terms used in this gem
    def self.attribute_mapping
      [["id", "id"],["weergavenaam", "name"],["mag_online", "visible_online"],["aantal_personen", "number_of_people"], ["mag_online_geboekt_worden_achteraf_betalen", "allowed_to_pay_later"], ["regels", Recras::CombinationItem], ["programma", Recras::Itinerary], ["onlineboeking_contactformulier_id", "contact_form_id"], ["prijs_pp_inc","price_per_person_incl_vat"], ["prijs_totaal_inc","price_total_incl_vat"]]
    end

    private

    def convert_date(date)
      if date.is_a?(Time)
        return date.iso8601
      elsif date.is_a?(String)
        return Time.parse(date).iso8601
      else
        raise RecrasError.new(self), "Date is required and must be of type Time or String (ISO 8601)."
      end
    end

    def convert_items(items, number_of_people)
      if items.any?
        # TODO
      elsif number_of_people && number_of_people > 0
        # assume that all the items will be chose the same amount
        items = []
        for combination_item in combination_items
          items << {combination_item_id: combination_item.id, number_of_people: number_of_people}
        end
      end

      if items && items.any?
        mappings = {combination_item_id: "arrangementsregel_id", number_of_people: "aantal"}
        product_items = []
        for item in items
          product_items << item.map {|k, v| [mappings[k], v] }.to_h
        end
        return product_items
      end

      return items
    end

  end
end
