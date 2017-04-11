# load external dependencies first
require 'httparty'
require 'time'

# load own classes
require "recras/version"
require "recras/config"
require "recras/recras_error"
# require "recras/api" not needed anymore, is now in client.rb
require "recras/client"
require "recras/person"
require "recras/combination"
require "recras/combination_item"
require "recras/contact_form"
require "recras/contact_form_field"
require "recras/booking"

module Recras

	API_VERSION = 2

  # returns the version number
  def self.version
    VERSION
  end 

  # this method maps the recras API objects to 
  # the names used by this gem
  def self.object_mappings
  	[["personeel", Person], ["arrangement", Combination], ["contactformulier", ContactForm], ["velden", ContactFormField], ["booking", Booking]]
  end

  def self.url
    "https://demo.recras.nl"
  end

  # initialize a new Person from given JSON.
  def new_from_json(json) 
    params = {}

    # set each attribute based on the mapping
    self.attribute_mapping.each do |o,n| 
      # if o is a string, parse it
      if n.is_a?(String)
        # check if data type is specified (using @@ symbol)
        if n.include?("@@")
          if n.split("@@").last.downcase == 'time'
           data = Time.new(n.split("@@").first)
           # puts data.inspect
           # raise ERR
          else
            data = n.split("@@").first
          end
          params[n.split("@@").first] = data
        else
          params[n] = json[o.to_s]
        end
        
      # else, o is a class. Call the 'parse_children' method on it
      else
        # puts "n is a #{n.class.name}"
        # loop through all the children (for example: 'regels' on 'arrangementen')
        if json[o]
          children = []
          for item in json[o]
            children << n.new_from_json(item)
          end
          params[n.plural_name] = children
        end
      end
    end
    self.new(params)
  end

	def self.parse_json(json: nil, endpoint: nil, client: nil)
    if json.is_a?(Hash) && json["error"]
      if json["message"]
        raise RecrasError.new(self), json["message"]
      else
        raise RecrasError.new(self), json["error"]["message"]
      end
    else
      Recras.object_mappings.each do |key,klass|
  	    if endpoint.match(key)
          # puts "Making new #{klass.name} with data: #{json}"
          obj = klass.new_from_json(json)
          if client
            obj.client = client
          end
  	      return obj
  	    end
  	  end
      raise RecrasError.new(self), "Unknwon object '#{endpoint}'"
    end
  end

  # communicates with the server and returns either:
  # - an object (Person, Booking)
  # - an error
  # - a json object
  def self.make_request(endpoint, body: {}, http_method: :get, client: nil)
    url = "#{Recras.url}/api#{Recras::API_VERSION}/#{endpoint}"

    auth = client ? {username: client.username, password: client.password} : nil

    if http_method && http_method.to_s == 'post'
      response = HTTParty.post(url, basic_auth: auth, body: body)
    else
      response = HTTParty.get(url, basic_auth: auth, body: body)
    end
    
    json = response.parsed_response
    return json
  end

end