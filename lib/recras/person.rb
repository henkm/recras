module Recras

  class Person
    extend Recras
    # @note The is a required parameter.
    attr_accessor :first_name
    attr_accessor :id
    attr_accessor :name
    attr_accessor :address
    attr_accessor :postal_code
    attr_accessor :city
    attr_accessor :country_code
    attr_accessor :region_code
    attr_accessor :vat_number
    attr_accessor :company_id
    attr_accessor :bank_account_number
    attr_accessor :first_name
    attr_accessor :last_name
    attr_accessor :phone
    attr_accessor :email


    #
    # Initializer to transform a +Hash+ into an Client object
    #
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

    # translates the mapping between the Recras API
    # and the terms used in this gem
    def self.attribute_mapping
      [["id", "id"],["displaynaam", "name"],["adres", "address"],["postcode", "postal_code"], ["plaats", "city"], ["landcode", "country_code"],["bedrijf_id", "company_id"],["telefoon1","phone"],["email1", "email"]]
    end

  end
end
