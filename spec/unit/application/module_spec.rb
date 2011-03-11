#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')
require 'puppet/application/module'

describe Puppet::Application::Module do
  it "should be a subclass of Puppet::Application::InterfaceBase" do
    Puppet::Application::Module.superclass.should equal(Puppet::Application::InterfaceBase)
  end
end
