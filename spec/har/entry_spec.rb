require File.expand_path("../../spec_helper", __FILE__)

module HAR
  describe Entry do
    let(:entry) { Entry.new json(fixture_path("entry1.json"))}

    it "has a request" do
      entry.request.should be_kind_of(Request)
    end

    it "has a response" do
      entry.response.should be_kind_of(Response)
    end

    it "should be successful if response has no error" do
      entry.response.stub(:is_error?).and_return(false)
      entry.should be_successful
    end

    it "should not be successful if response has an error" do
      entry.response.stub(:is_error?).and_return(true)
      entry.should_not be_successful
    end

    context "delegated methods from response" do
      it "should include :response_code as an alias for response.status" do
        entry.response_code.should == entry.response.status
      end

      # predicates
      %w[error? client_error? server_error? connection_error?
         redirect? html? image? javascript? css?
         flash? video? redirected_to has_header? has_headers?
         have_header? have_headers?
        ].each do |meth|
        it "should include :#{meth}" do
          entry.should respond_to(meth)
          entry.send(meth).should == entry.response.send(meth)
        end
      end

      # methods that take arguments
      [:content_type?, :has_content?, :have_content?, :match_content?,
       :matches_content?, :get_header
      ].each do |meth|
        it "should include #{meth}" do
          entry.should respond_to(meth)
          entry.send(meth,'video').should == entry.response.send(meth,'video')
        end
      end

    end

    context "delegated methods from request" do
      it "should include :url" do
        entry.should respond_to(:url)
        entry.url.should == entry.request.url
      end
    end

  end # Entry
end # HAR
