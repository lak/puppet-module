#!/usr/bin/env ruby

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper.rb')
require 'puppet/interface/module'

describe Puppet::Interface.interface(:module) do
  before do
    @interface = Puppet::Interface.interface(:module)
  end

  it "should be a subclass of 'Interface'" do
    @interface.should be_instance_of(Puppet::Interface)
  end
end
