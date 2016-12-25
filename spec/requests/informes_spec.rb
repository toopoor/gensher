require 'spec_helper'

describe "Informes" do
  describe "GET /informes" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get informes_path
      response.status.should be(200)
    end
  end
end
