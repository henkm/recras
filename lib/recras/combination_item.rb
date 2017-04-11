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
    attr_accessor :description
    attr_accessor :number_of_people
    attr_accessor :product_id
    
    # Initializer to transform a +Hash+ into an Client object    
    # @param [Hash] args
    def initialize(args=nil)
      required_args = []
      return if args.nil?
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    def self.plural_name
      "combination_items"
    end

    # translates the mapping between the Recras API
    # and the terms used in this gem
    def self.attribute_mapping
      [["id", "id"],["locatie_id", "location_id"],["begin", "begins_at@@time"],["eind", "ends_at@@time"], ["beschrijving", "description"], ["aantal_personen", "number_of_people"], ["product_id", "product_id"]]
    end

  end
end
