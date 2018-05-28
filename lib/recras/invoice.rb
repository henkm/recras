module Recras
  
  # links to 'arrangement_regels' in the API
  # http://recras.github.io/docs/endpoints/facturen.html
  class Invoice
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
        ["status", "status"]
      ]
    end


    def make_payment(status: "concept", comment: "", payment_method_id: nil, amount: 0.0)
      body_data = {
        factuur_id: id,
        betaalmethode_id: payment_method_id,
        bedrag: amount
      }
      json = client.make_request("facturen/#{id}/betalingen", body: body_data.to_json, http_method: :post)
      if json.is_a?(Hash) && json["error"]
        raise RecrasError.new(self), json["error"]["message"]
      else
        payment = Recras.parse_json(json: json, endpoint: "betalingen")
        return payment
      end

    end

  end
end
