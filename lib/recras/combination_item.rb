module Recras
  
  # links to 'arrangement_regels' in the API
  # http://recras.github.io/docs/endpoints/arrangementen.html
  class CombinationItem
    extend Recras
    # @note The is a required parameter.

    attr_accessor :id
    attr_accessor :location_id
    attr_accessor :begins_at
    attr_accessor :ends_at
    attr_accessor :name
    attr_accessor :description
    attr_accessor :number_of_people
    attr_accessor :product_id
    attr_accessor :price
    attr_accessor :minimum
    attr_accessor :json
    
    # Initializer to transform a +Hash+ into an Client object    
    # @param [Hash] args
    def initialize(args=nil)
      required_args = []
      return if args.nil?
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
      set_values_from_json
    end

    def self.plural_name
      "combination_items"
    end

    # translates the mapping between the Recras API
    # and the terms used in this gem
    def self.attribute_mapping
      [["id", "id"],["locatie_id", "location_id"],["begin", "begins_at@@time"],["eind", "ends_at@@time"], ["beschrijving", "description"], ["verkoop", "price@@float"], ["aantal_personen", "number_of_people"], ["product_id", "product_id"]]
    end

    private

    def set_values_from_json
      self.price = json["product"]["verkoop"].to_f
      self.name = json["product"]["naam"]
      self.minimum = json["product"]["minimum_aantal"].to_i
    end

  end
end
