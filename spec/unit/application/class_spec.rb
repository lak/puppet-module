#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')
require 'puppet/application/class'

describe Puppet::Application::Class do
  it "should be a subclass of Puppet::Application::InterfaceBase" do
    Puppet::Application::Class.superclass.should equal(Puppet::Application::InterfaceBase)
  end
end
