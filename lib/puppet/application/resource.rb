require 'puppet/application'
require 'puppet/application/indirection_base'

class Puppet::Application::Resource < Puppet::Application::IndirectionBase
  attr_accessor :host

  option("--host HOST","-H") do |arg|
    @host = arg
  end

  option("--param PARAM", "-p") do |arg|
    @extra_params << arg.to_sym
  end

  def oldmain
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
    else
      puts text
    end
  end
end
