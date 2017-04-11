module Recras
  
  # links to 'arrangement_regels' in the API
  # http://recras.github.io/docs/endpoints/contactformulieren.html
  class Booking
    extend Recras
    # @note The is a required parameter.

    attr_accessor :id
    attr_accessor :status
    attr_accessor :message
    attr_accessor :customer_id
    attr_accessor :payment_url
    
    # Initializer to transform a +Hash+ into an Client object    
    # @param [Hash] args
    def initialize(args=nil)
      required_args = []
      return if args.nil?
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    # translates the mapping between the Recras API
    # and the terms used in this gem
    def self.attribute_mapping
      [
        ["id", "id"],
        ["status", "status"],
        ["message", "message"], 
        ["boeking_id", "id"], 
        ["klant_id", "customer_id"], 
        ["payment_url", "payment_url"]
      ]
    end

  end
end
