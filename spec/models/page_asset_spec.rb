require File.dirname(__FILE__) + '/../spec_helper'

describe PageAsset do
  before(:each) do
    @page_asset = PageAsset.new
  end

  it "should be valid" do
    @page_asset.should be_valid
  end
end
