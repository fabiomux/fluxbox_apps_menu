require 'thor'
require 'fluxbox_apps_menu'
require 'fluxbox_apps_menu/version'

module FluxboxAppsMenu

  class CLI < Thor

    desc 'build', 'Build the menu'
    method_option :filename, :aliases => '-f', :default => '', :desc => 'Save as filename.'
    method_option :silent, :aliases => '-s', :default => false, :type => :boolean, :desc => 'Don\'t show any output message.'
    method_option :overwrite, :aliases => '-o', :default => true, :type => :boolean, :desc => 'Overwrite the app menu if exists.'
    def build
      FluxboxAppsMenu::Builder.new(options).create_menu
    end

    desc 'menuconfig', 'Make a local copy of the configuration file.'
    method_option :overwrite, :aliases => '-o', :default => false, :type => :boolean, :desc => 'Overwrite the config file if exists.'
    def menuconfig
      FluxboxAppsMenu::Builder.new(options).init_config
    end
      
    def help(arg = nil)
      if arg.nil?
        puts <<EOL
Fluxbox Apps Menu v.#{FluxboxAppsMenu::VERSION} by Fabio Mucciante

Description:
  Build a Fluxbox menu putting the applications in the right
  section as configured within the "fluxbox_apps_menu.yaml" file.

  Using the "menuconfig" task a copy of this file will be created
  under the "~/.fluxbox" path.

  The default menu file is located in "~/.fluxbox/menu-apps".

EOL
        super
      else
        super arg
      end
    end

    default_task :build
  end

end 
