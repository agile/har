module HAR
  class Response < SchemaType

    attr_reader :entries

    def initialize(input)
      super(input)
    end

    def is_error?
      status >= 400
    end
    alias :error? :is_error?

    def is_client_error?
      is_error? && status < 500
    end
    alias :client_error? :is_client_error?

    def is_server_error?
      status >= 500 && status != 504
    end
    alias :server_error? :is_server_error?

    def is_connection_error?
      status == 504 || status == 0
    end
    alias :connection_error? :is_connection_error?

    def is_redirect?
      [301,302,307].include?(status)
    end
    alias :redirect? :is_redirect?
    alias :redirected? :is_redirect?

    def is_content_type? type
      !!content.mime_type.include?(type)
    end
    alias :has_content_type? :is_content_type?
    alias :content_type? :is_content_type?

    def is_html?
      is_content_type? 'html'
    end
    alias :html? :is_html?

    def is_image?
      is_content_type? 'image'
    end
    alias :image? :is_image?

    def is_javascript?
      is_content_type? 'javascript'
    end
    alias :javascript? :is_javascript?

    def is_css?
      is_content_type? 'css'
    end
    alias :css? :is_css?

    def is_flash?
      is_content_type? 'flash'
    end
    alias :flash? :is_flash?

    def is_video?
      is_content_type? 'video'
    end
    alias :video? :is_video?

    def is_other?
      !is_html? && !is_image? && !is_javascript? && !is_css? && !is_flash? && !is_video?
    end
    alias :other? :is_other?

    def has_content?(c=nil)
      case c
      when nil then
        !!(content.text && content.text.to_s.size > 0)
      when Regexp then
        !!(content.text && content.text.to_s =~ c)
      else
        content.text && content.text.to_s.include?(c)
      end
    end
    alias :have_content? :has_content?
    alias :match_content? :has_content?
    alias :matches_content? :has_content?

    def redirected_to
      if is_redirect?
        location = Array(headers).detect {|h| h["name"] =~ /location/i }
        location && location["value"]
      end
    end

  end
end
