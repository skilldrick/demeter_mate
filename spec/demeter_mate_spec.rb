require "spec_helper"
require 'active_support'
require 'active_record'
require 'action_controller'
require 'action_view'

describe DemeterMate do
  context "has_many relationship" do
    before do
      class Sample
        include DemeterMate
        demeter_mate :friends
      end

      @sample = Sample.new
      @friends = mock
      @sample.stub!(:friends).and_return(@friends)
    end

    it "should not give expose internal methods" do
      @sample.should_not respond_to(:get_object_and_method)
    end

    it "should respond_to :friends" do
      @sample.should respond_to(:friends)
    end

    it "should return @friends" do
      @sample.friends.should eq(@friends)
    end

    it "should respond_to size_friends" do
      @sample.should respond_to(:size_friends)
    end

    it "should respond_to friends_size" do
      @sample.should respond_to(:friends_size)
    end

    it "should call @friends.size when size_friends is called" do
      @friends.should_receive(:size)
      @sample.size_friends
    end

    it "should call @friends.find when find_friends is called" do
      @friends.should_receive(:find).with("1")
      @sample.find_friend "1"
    end

    it "should pass a block when given" do
      stub_block_was_called = false
      sum_block_was_called = false

      @friends.stub!(:sum) do |key, block|
        stub_block_was_called = true
        block.call.should eq(:success)
      end

      @sample.sum_friends(:age) do
        sum_block_was_called = true
        :success
      end

      stub_block_was_called.should be_true
      sum_block_was_called.should be_true
    end

    it "should respond_to emtpy_friends?" do
      @sample.should respond_to(:empty_friends?)
    end

    it "should respond_to friends_empty?" do
      @sample.should respond_to(:friends_empty?)
    end

    it "should call empty? when empty_friends? called" do
      @friends.should_receive(:empty?)
      @sample.empty_friends?
    end

    it "should call empty? when friends_empty? called" do
      @friends.should_receive(:empty?)
      @sample.friends_empty?
    end
  end

  context "has_one relationship" do
    before do
      class Sample
        include DemeterMate
        demeter_mate :best_friend
      end

      @sample = Sample.new
      @best_friend = mock
      @sample.stub!(:best_friend).and_return(@best_friend)
    end

    it "should call create! on best_friend" do
      attributes = { :name => 'Dave', :age => 18 }
      @best_friend.should_receive(:create!).with(attributes)
      @sample.create_best_friend! attributes
    end

  end



end

