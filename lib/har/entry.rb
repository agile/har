require 'forwardable'
module HAR
  class Entry < SchemaType
    extend Forwardable

    def_delegators :response, *[:error?, :client_error?, :server_error?,
                                :connection_error?, :redirect?, :content_type?,
                                :html?, :image?, :javascript?, :css?, :flash?,
                                :video?, :content_type?, :has_content?,
                                :have_content?, :matches_content?,
                                :match_content?,  :redirected_to, :get_header,
                                :has_header?, :has_headers?, :have_header?,
                                :have_headers?
    ]

    def_delegators :request, *[:url]
    def initialize(input)
      super(input)
    end

    def response_code
      response.status
    end

    def successful?
      !response.is_error?
    end

  end
end
