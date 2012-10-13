require 'spec_helper'

describe Truenames::Matchers::ExprEq do
  it "matches when actual == expected" do
    1.should expr_eq(1)
  end

  it "does not match when actual != expected" do
    1.should_not expr_eq(2)
  end

  it "compares by sending == to actual (not expected)" do
    called = false
    actual = Class.new do
      define_method :== do |other|
        called = true
      end
    end.new

    actual.should expr_eq :anything # to trigger the matches? method
    called.should be_true
  end

  it "describes itself" do
    matcher = expr_eq(1)
    matcher.matches?(1)
    matcher.description.should eq "eq 1"
  end

  it "provides message, expected and actual on #failure_message" do
    matcher = expr_eq("1")
    matcher.matches?(1)
    matcher.failure_message_for_should.should eq "\nexpected: \"1\"\n     got: 1\n\n(compared using ==)\n"
  end

  it "provides message, expected and actual on #negative_failure_message" do
    matcher = expr_eq(1)
    matcher.matches?(1)
    matcher.failure_message_for_should_not.should eq "\nexpected: value != 1\n     got: 1\n\n(compared using ==)\n"
  end

  it "provides local variable reference when available" do
    abc = 123
    bcd = 234

    matcher = expr_eq(abc)
    matcher.matches?(bcd)
    matcher.failure_message_for_should.should eq "\nexpected: 123 (abc)\n     got: 234 (bcd)\n\n(compared using ==)\n"
  end

  it "provides multiple local variable references when they exist" do
    zab = 123
    abc = 123
    bcd = 234
    cde = 234

    matcher = expr_eq(abc)
    matcher.matches?(bcd)
    matcher.failure_message_for_should.should eq "\nexpected: 123 (zab, abc)\n     got: 234 (bcd, cde)\n\n(compared using ==)\n"
  end
end
