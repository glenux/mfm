require "../spec_helper"
require "../../src/utils/breadcrumbs"

describe GX::Utils::BreadCrumbs do
  context "Initialization" do
    it "can initialize from array" do
      # empty string
      b1 = GX::Utils::BreadCrumbs.new([] of String)
      b1.to_a.should be_empty

      # simple string
      b2 = GX::Utils::BreadCrumbs.new(["test1"])
      b2.to_a.should eq(["test1"])

      # array
      b3 = GX::Utils::BreadCrumbs.new(["test1", "test2"])
      b3.to_a.should eq(["test1", "test2"])
    end
  end

  context "Functioning" do
    it "can add values" do
      # empty string
      b1 = GX::Utils::BreadCrumbs.new([] of String)
      b1.to_a.should be_empty

      # simple string
      b2 = b1 + "test1"
      b2.to_a.should eq(["test1"])

      b3 = b2 + "test2"
      b3.to_a.should eq(["test1", "test2"])
    end

    it "can become a string" do
      b1 = GX::Utils::BreadCrumbs.new([] of String)
      b1.to_s.should eq("")

      b2 = b1 + "test1"
      b2.to_a.should eq("test1")

      b3 = b2 + "test2"
      b3.to_a.should eq("test1 test2")
    end
  end
end
