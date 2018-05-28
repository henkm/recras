module Recras
  
  class Payment
    extend Recras
    # @note The is a required parameter.

    attr_accessor :id
    attr_accessor :status
    
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
        ["status", "status"]
      ]
    end

  end
end
