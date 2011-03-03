require 'puppet/interface'

Puppet::Interface.new :forge do
#  desc "clean", "Clears module cache for all repositories"
  action :clean do
    Puppet::Module::Tool::Applications::Cleaner.run(arguments)
  end

  # TODO Review whether the 'release' feature should be fixed or deleted.
#  desc "release FILENAME", "Release a module tarball (.tar.gz)"
#  method_option_repository
#  def release(filename)
#    Puppet::Module::Tool::Applications::Releaser.run(filename, options)
#  end

  # TODO Review whether the 'unrelease' feature should be fixed or deleted.
#  desc "unrelease MODULE_NAME", "Unrelease a module (eg, 'user-modname')"
#  method_option :version, :alias => :v, :required => true, :desc => "The version to unrelease"
#  method_option_repository
#  def unrelease(module_name)
#    Puppet::Module::Tool::Applications::Unreleaser.run(module_name,
#                                                       options)
#  end

#  desc "search TERM", "Search the module repository for a module matching TERM"
#  method_option_repository
  action :search do |term|
    Puppet::Module::Tool::Applications::Searcher.run(term, arguments)
  end

  # TODO Review whether the 'register' feature should be fixed or deleted.
#  desc "register MODULE_NAME", "Register a new module (eg, 'user-modname')"
#  method_option_repository
#  def register(module_name)
#    Puppet::Module::Tool::Applications::Registrar.run(module_name, options)
#  end
end
