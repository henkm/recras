module Recras
  
  # links to 'arrangement_regels' in the API
  # http://recras.github.io/docs/endpoints/contactformulieren.html
  class ContactFormField
    extend Recras
    # @note The is a required parameter.

    attr_accessor :id
    attr_accessor :name
    attr_accessor :contact_form_id
    attr_accessor :input_type
    attr_accessor :required
    attr_accessor :options
    attr_accessor :special_for_booking
    attr_accessor :field_identifier
    attr_accessor :contact_form
    attr_accessor :client
    
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
        ["naam", "name"],
        ["contactformulier_id", "contact_form_id"], 
        ["soort_invoer", "input_type"], 
        ["verplicht", "required"], 
        ["mogelijke_keuzes", "options"],
        ["bijzonderheden_boeking", "special_for_booking"],
        ["field_identifier", "field_identifier"]
      ]
    end

    # returns default values for this field_identifier
    def default_value
      if field_identifier == "contactpersoon.email1"
        return "test@example.org"
      elsif field_identifier == "contactpersoon.naam"
        return "Naamloos"
      elsif field_identifier == "contactpersoon.voornaam"
        return "Voornaam"
      elsif field_identifier == "contactpersoon.achternaam"
        return "Achternaam"
      elsif field_identifier == "veel_tekst"
        return "tekst"
      else
        # raise ERRR
        return ""
      end
    end

  end
end
