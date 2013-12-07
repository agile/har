module HAR
  describe Response do
    let(:entry) { Entry.new json(fixture_path("entry1.json"))}
    let(:response) { entry.response }

    context "error?" do
      it "should be true if status >= 400" do
        response.stub(:status).and_return(400)
        response.should be_error
      end
      it "should be false if status < 400" do
        response.status.should be < 400
        response.should_not be_error
      end
    end

    context "client_error?" do
      it "should be true if status between 400 and 499" do
        response.stub(:status).and_return(400)
        response.should be_client_error
      end
      it "should be false if status < 400" do
        response.status.should be < 400
        response.should_not be_client_error
      end
      it "should be false if status >= 500" do
        response.stub(:status).and_return(503)
        response.should_not be_client_error
      end
    end

    context "server error?" do
      it "should be true if status >= 500" do
        response.stub(:status).and_return(503)
        response.should be_server_error
      end
      it "should not be true if status is 504" do
        response.stub(:status).and_return(504)
        response.should_not be_server_error
      end
      it "should not be true if status under 500" do
        response.stub(:status).and_return(404)
        response.should_not be_server_error
      end
    end

    context "connection error?" do
      it "should be true if status is 0" do
        response.stub(:status).and_return(0)
        response.should be_connection_error
      end
      it "should be true if status is 504" do
        response.stub(:status).and_return(504)
        response.should be_connection_error
      end
    end

    context "redirect?" do
      [301, 302, 307].each do |status|
        it "should be true if status #{status}" do
          response.stub(:status).and_return(status)
          response.should be_redirect
        end
      end
      it "is aliased as :redirected?" do
        response.should respond_to(:redirected?)
      end
      it "is aliased as :is_redirect?" do
        response.should respond_to(:is_redirect?)
      end
    end

    context "is_content_type?" do
      it "should be true given 'text/html' and mime type of content is 'text/html'" do
        response.content.stub(:mime_type).and_return('text/html')
        response.should have_content_type('text/html')
        response.should be_content_type('text/html')
      end
      it "should be true given 'text/html' and mime type of content is 'text/html; charset=iso-8859-1'" do
        response.content.stub(:mime_type).and_return('text/html; charset=iso-8859-1')
        response.should have_content_type('text/html')
        response.should be_content_type('text/html')
      end
    end

    context "html?" do
      it "should be true when content type html" do
        response.content.stub(:mime_type).and_return('text/html; charset=iso-8859-1')
        response.should be_html
      end
    end

    context "image?" do
      it "should be true when content type image" do
        response.content.stub(:mime_type).and_return('image/gif')
        response.should be_image
      end
    end

    context "javascript?" do
      it "should be true when content type javascript" do
        response.content.stub(:mime_type).and_return('text/javascript')
        response.should be_javascript
      end
    end

    context "css?" do
      it "should be true when content type css" do
        response.content.stub(:mime_type).and_return('text/css')
        response.should be_css
      end
    end

    context "flash?" do
      it "should be true when content type flash" do
        response.content.stub(:mime_type).and_return('application/x-shockwave-flash')
        response.should be_flash
      end
    end

    context "video?" do
      it "should be true when content type video" do
        response.content.stub(:mime_type).and_return('video/mp4')
        response.should be_video
      end
    end

    context "other?" do
      it "should be true when content type not recognized" do
        response.content.stub(:mime_type).and_return('multipart/mixed')
        response.should be_other
      end
    end

    context "has_content?(string)" do
      it "should be true when content text includes string" do
        response.content.stub(:text).and_return('welcome to my hello world page')
        response.should have_content("hello world")
      end
      it "should be false when content text does not include string" do
        response.content.stub(:text).and_return('welcome to my hello world page')
        response.should_not have_content("goodbye world")
      end
    end

    context "has_content?(expression)" do
      it "should be true when content text match expression" do
        response.content.stub(:text).and_return('welcome to my hello world page')
        response.should have_content(/hello world/)
      end
      it "should be false when content text does not match expression" do
        response.content.stub(:text).and_return('welcome to my hello world page')
        response.should_not have_content(/goodbye world/)
      end
    end

    context "redirected_to" do
      it "should be nil if not redirected" do
        response.stub(:is_redirect?).and_return(false)
        response.stub(:headers).and_return([{"name" => "Location", "value" => "http://google.com/"}])
        response.should_not be_is_redirect

        response.redirected_to.should be_nil
      end

      it "should be nil if no headers" do
        response.stub(:is_redirect?).and_return(true)
        response.should be_is_redirect
        response.stub(:headers).and_return([])

        response.redirected_to.should be_nil
      end

      it "should match the location header if redirected" do
        response.stub(:is_redirect?).and_return(true)
        response.should be_is_redirect
        response.stub(:headers).and_return([{"name" => "Location", "value" => "http://google.com/"}])
        response.redirected_to.should == "http://google.com/"
      end

    end
  end
end
