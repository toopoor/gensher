require 'spec_helper'

describe InstrumentsController do

  describe "GET 'first_line'" do
    it "returns http success" do
      get 'first_line'
      response.should be_success
    end
  end

  describe "GET 'invited'" do
    it "returns http success" do
      get 'invited'
      response.should be_success
    end
  end

  describe "GET 'active'" do
    it "returns http success" do
      get 'active'
      response.should be_success
    end
  end

end
