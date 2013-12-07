module HAR
  describe Request do
    let(:entry) { Entry.new json(fixture_path("entry1.json"))}
    let(:request) { entry.request }

    context "domain" do
      it "should be fqdn host from request url" do
        request.domain.should == request.url[/^https?:..([^\/:]+)/,1]
      end
    end
  end
end
