require 'thor'
require 'fluxbox_apps_menu'
require 'fluxbox_apps_menu/version'

module FluxboxAppsMenu

  class CLI < Thor

    desc 'build', 'Build the menu'
    method_option :filename, :aliases => '-f', :default => '', :desc => 'Save as the specified filename.'
    method_option :silent, :aliases => '-s', :default => false, :type => :boolean, :desc => 'Don\'t show any output message.'
    method_option :overwrite, :aliases => '-o', :default => true, :type => :boolean, :desc => 'Overwrite the app menu if exists.'
    def build
      FluxboxAppsMenu::Builder.new(options).create_menu
    end

    desc 'menuconfig', 'Copy the menu configuration file under the local ".fluxbox" directory.'
    method_option :overwrite, :aliases => '-o', :default => false, :type => :boolean, :desc => 'Overwrite the config file if exists.'
    def menuconfig
      FluxboxAppsMenu::Builder.new(options).init_config
    end
      
    def help
      puts <<EOL

Fluxbox Apps Menu v.#{FluxboxAppsMenu::VERSION} by Fabio Mucciante

Description:
  Build a Fluxbox menu including only the applications following
  the directives included within the "fluxbox_apps_menu.yaml" file
  which can be overriden copying it in the local ".fluxbox" directory.

EOL
      super
    end

    default_task :build
  end

end 
