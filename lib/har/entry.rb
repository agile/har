require 'forwardable'
module HAR
  class Entry < SchemaType
    extend Forwardable

    def_delegators :response, *[:client_error?, :connection_error?,
                                :content_type?, :css?, :error?, :flash?,
                                :get_header, :has_content?, :has_header?,
                                :has_headers?, :have_content?, :have_header?,
                                :have_headers?, :html?, :image?, :javascript?,
                                :match_content?, :matches_content?,
                                :redirect?, :redirected_to, :server_error?,
                                :video?,
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
