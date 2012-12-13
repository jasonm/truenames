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
    matcher.failure_message_for_should.should eq "\nexpected: abc\n     got: bcd\n\n(compared using ==)\n"
  end

  it "provides multiple local variable references when they exist" do
    zab = 123
    abc = 123
    bcd = 234
    cde = 234

    matcher = expr_eq(abc)
    matcher.matches?(bcd)
    matcher.failure_message_for_should.should eq "\nexpected: zab or abc\n     got: bcd or cde\n\n(compared using ==)\n"
  end

  it "provides instance variable reference when available" do
    @abc = 123
    @bcd = 234

    matcher = expr_eq(@abc)
    matcher.matches?(@bcd)
    matcher.failure_message_for_should.should eq "\nexpected: @abc\n     got: @bcd\n\n(compared using ==)\n"
  end

  it "provides local variable references inside arrays" do
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5

    matcher = expr_eq([a,b,c])
    matcher.matches?([c,d,e])
    matcher.failure_message_for_should.should eq "\nexpected: [a, b, c]\n     got: [c, d, e]\n\n(compared using ==)\n"
  end

  it "displays ambiguous matches inside arrays " do
    z = 1
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
    f = 5

    matcher = expr_eq([a,b,c])
    matcher.matches?([c,d,e])
    matcher.failure_message_for_should.should eq "\nexpected: [z or a, b, c]\n     got: [c, d, e or f]\n\n(compared using ==)\n"
  end

  context "with let statements" do
    let(:hello) { "hello" }

    it "displays references to let statements" do
      matcher = expr_eq("goodbye")
      matcher.matches?(hello)
      matcher.failure_message_for_should.should eq "\nexpected: \"goodbye\"\n     got: let(:hello)\n\n(compared using ==)\n"
    end
  end

  context "with let! statements" do
    let!(:hello) { "hello" }

    it "displays references to let! statements as let statements" do
      matcher = expr_eq("goodbye")
      matcher.matches?(hello)
      matcher.failure_message_for_should.should eq "\nexpected: \"goodbye\"\n     got: let(:hello)\n\n(compared using ==)\n"
    end
  end
end
