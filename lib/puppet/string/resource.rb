require 'puppet/string/indirector'
require 'puppet/node/facts'

Puppet::String::Indirector.new(:resource) do

  action :edit do |type, name|
    text = run_unnamed_collect_method(type, name)
    file = "/tmp/puppet-resource-#{Process.pid}.pp"
    begin
      File.open(file, "w") do |f|
        f.puts text
      end
      ENV["EDITOR"] ||= "vi"
      system(ENV["EDITOR"], file)
      system("puppet -v #{file}")
    ensure
      #if FileTest.exists? file
      #    File.unlink(file)
      #end
    end
  end
end
