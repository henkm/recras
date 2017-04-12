module Recras
  
  # links to 'programma' in the API
  # http://recras.github.io/docs/endpoints/arrangementen.html
  class Itinerary
    extend Recras
    # @note The is a required parameter.

    attr_accessor :description
    attr_accessor :quantity
    attr_accessor :quantity_type
    attr_accessor :start_time
    attr_accessor :end_time
    attr_accessor :duration
    
    # Initializer to transform a +Hash+ into an Client object    
    # @param [Hash] args
    def initialize(args=nil)
      required_args = []
      return if args.nil?
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    # outputs a nice readable itinerary
    def to_s
      "#{description} - #{quantity} #{quantity_type} (#{duration_string})"
    end

    def duration_string
      "#{duration_hours.to_s.rjust(2, '0')}:#{duration_minutes.to_s.rjust(2, '0')}:#{duration_seconds.to_s.rjust(2, '0')}"
    end

    def duration_hours
      begin
        duration.split("PT").last.split("H").first.to_i
      rescue
        nil
      end
    end

    def duration_minutes
      begin
        duration.split("H").last.split("M").first.to_i
      rescue
        nil
      end
    end

    def duration_seconds
      begin
        duration.split("M").last.split("S").first.to_i
      rescue
        nil
      end
    end
    def self.plural_name
      "itineraries"
    end

    # translates the mapping between the Recras API
    # and the terms used in this gem
    def self.attribute_mapping
      [["omschrijving", "description"], ["aantal", "quantity"], ["wat", "quantity_type"], ["begin", "start_time"], ["duur", "duration"], ["eind", "end_time"]]
    end

  end
end
