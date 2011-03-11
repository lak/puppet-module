require 'puppet/application/interface_base'

class Puppet::Application::Do < Puppet::Application::InterfaceBase
  def main
    args = command_line.args
    type = args.shift or raise "You must specify the type to display"
    typeobj = Puppet::Type.type(type) or raise "Could not find type #{type}"
    name = args.shift
    params = {}
    args.each do |setting|
      if setting =~ /^(\w+)=(.+)$/
        params[$1] = $2
      else
        raise "Invalid parameter setting #{setting}"
      end
    end

    raise "You cannot edit a remote host" if options[:edit] and @host

    properties = typeobj.properties.collect { |s| s.name }

    format = proc {|trans|
      trans.dup.collect do |param, value|
        if value.nil? or value.to_s.empty?
          trans.delete(param)
        elsif value.to_s == "absent" and param.to_s != "ensure"
          trans.delete(param)
        end

        trans.delete(param) unless properties.include?(param) or @extra_params.include?(param)
      end
      trans.to_manifest
    }

    if @host
      Puppet::Resource.indirection.terminus_class = :rest
      port = Puppet[:puppetport]
      key = ["https://#{host}:#{port}", "production", "resources", type, name].join('/')
    else
      key = [type, name].join('/')
    end

    text = if name
      if params.empty?
        [ Puppet::Resource.find( key ) ]
      else
        [ Puppet::Resource.new( type, name, :parameters => params ).save( key ) ]
      end
    else
      Puppet::Resource.search( key, {} )
    end.map(&format).join("\n")

    if options[:edit]
      file = "/tmp/x2puppet-#{Process.pid}.pp"
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
    else
      puts text
    end
  end
end
