require 'puppet/string'
require 'puppet/module'

Puppet::String.new :class do
  action :commit do
    unless current
      raise "Not currently working on a class"
    end

    File.unlink(current_file)
    nil
  end

  # Show the current class
  action :show do
    return nil unless current

    current
  end

  action :start do |name|
    unless name
      raise "Usage: puppet class start <name>"
    end

    if current
      raise "Could not start on class '#{name}'; already working on '#{current}'"
    end

    modname, klass = module_and_class(name)
    mod = Puppet::Module.new(modname)

    if class_exists?(mod, klass)
      raise "Class '#{name}' already exists at '#{class_path(mod, name)}'"
    end

    File.open(current_file, "w") { |f| f.puts name }
    Puppet.notice "Ready to build class '#{name}'"
  end

  def class_exists?(mod, name)
    return false unless mod.exist?
    FileTest.exist?(class_path(mod, name))
  end

  def class_path(mod, name)
    File.join(mod.path, mod.manifests, name.gsub("::", File::SEPARATOR) + ".pp")
  end

  def current
    return nil unless FileTest.exist?(current_file)
    File.read(current_file).chomp
  end

  def current_file
    File.join(datadir, "current")
  end

  def datadir
    @datadir ||= File.join(Puppet[:confdir], ".class_assembler")

    unless FileTest.directory?(@datadir)
      FileUtils.mkdir_p(@datadir)
    end
    @datadir
  end

  def module_and_class(name)
    if name.include?("::")
      mod, tmp = name.split("::")
      return mod, tmp.join("::")
    else
      return name, name
    end
  end
end
