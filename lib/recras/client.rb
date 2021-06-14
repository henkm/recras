module Recras

  class Client
    attr_accessor :api_key
    # @note The is a required parameter.
    attr_accessor :username
    # @return [String] Your Recras password
    attr_accessor :password
    attr_accessor :host


    #
    # Initializer to transform a +Hash+ into an Client object
    #
    # @param [Hash] args
    def initialize(args=nil)
      required_args = [] # [:username, :password]
      for arg in required_args
        if args.nil? || args[arg].nil?
          raise RecrasError.new(self), "Insufficient login credentials. Please provide @username, @password and @host"
        end
      end

      return if args.nil?
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
      if password.present? && password.length == 32
        instance_variable_set("@api_key", password)
      end
    end

    # communicates with the server and returns either:
    # - an object (Person, Booking)
    # - an error
    # - a json object
    def make_request(endpoint, body: {}, http_method: :get)
      Recras.make_request(endpoint, body: body, http_method: http_method, client: self)
    end

    # returns true if credentials are valid, false otherwise
    def valid
      begin
        me
        return true
      rescue RecrasError
        return false
      end
    end
    alias_method :valid?, :valid

    # returns a Me object
    def me
      json = make_request("personeel/me")
      Recras.parse_json(json: json, endpoint: "personeel")
    end

    # find a specific combination
    def combination(id)
      json = make_request("arrangementen/#{id}")
      return Recras.parse_json(json: json, endpoint: "arrangementen", client: self)
    end


    # returns an array of available combinations
    def payment_methods
      result = make_request("betaalmethoden")
      a = []
      for json in result
        a << Recras.parse_json(json: json, endpoint: "betaalmethoden")
      end
      return a
    end


    # returns an array of available combinations
    def combinations
      result = make_request("arrangementen")
      a = []
      for json in result
        begin
          a << Recras.parse_json(json: json, endpoint: "arrangementen", client: self)
        rescue
          
        end
      end
      return a
    end

  end
end
