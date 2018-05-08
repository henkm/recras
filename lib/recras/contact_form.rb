module Recras
  
  # links to 'arrangement_regels' in the API
  # http://recras.github.io/docs/endpoints/contactformulieren.html
  class ContactForm
    extend Recras
    # @note The is a required parameter.

    attr_accessor :id
    attr_accessor :name
    attr_accessor :client
    attr_accessor :json
    # attr_accessor :contact_form_fields
    
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
      "contact_forms"
    end

    # returns an array of Recras::ContactFormField elements
    def contact_form_fields
      json = client.make_request("contactformulieren/#{id}/velden")
      a = []
      for element in json
        a << Recras.parse_json(json: element, endpoint: "velden", client: client)
      end
      return a
    end

    # returns the minimum required attributes to make a valid
    # booking. Only use this for testing purpose.
    def default_values
      a = {}
      for field in contact_form_fields
        a[field.field_identifier] = field.default_value
      end
      return a
    end
    

    # translates the mapping between the Recras API
    # and the terms used in this gem
    def self.attribute_mapping
      [["id", "id"],["name", "name"]]
    end

  end
end
