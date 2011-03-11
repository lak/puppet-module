require 'puppet/interface'
require 'puppet/module/tool'

Puppet::Interface.new :module do
  action :version do
    say Puppet::Module::Tool.version
  end


#  desc "generate USERNAME-MODNAME", "Generate boilerplate for a new module"
#  method_option_repository
  action :generate do |name|
    Puppet::Module::Tool::Applications::Generator.run(name, arguments)
  end

#  desc "build [PATH_TO_MODULE]", "Build a module for release"
  action :build do |path|
    Puppet::Module::Tool::Applications::Builder.run(find_module_root(path), arguments)
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

#  desc "install MODULE_NAME_OR_FILE [OPTIONS]", "Install a module (eg, 'user-modname') from a repository or file"
#  method_option :version, :alias => :v, :desc => "Version to install (can be a requirement, eg '>= 1.0.3', defaults to latest version)"
#  method_option :force, :alias => :f, :type => :boolean, :desc => "Force overwrite of existing module, if any"
#  method_option_repository
  action :install do |name|
    Puppet::Module::Tool::Applications::Installer.run(name, arguments)
  end

#  desc "changes [PATH_TO_MODULE]", "Show modified files in an installed module"
  action :changes do |path|
    Puppet::Module::Tool::Applications::Checksummer.run(find_module_root(path), arguments)
  end

#  desc "repository", "Show currently configured repository"
  action :repository do
    Puppet::Module::Tool.prepare_settings(arguments)
    say Puppet.settings[:puppet_module_repository]
  end
end
