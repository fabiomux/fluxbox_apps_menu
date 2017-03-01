require 'thor'
require 'fluxbox_apps_menu'
require 'fluxbox_apps_menu/version'

module FluxboxAppsMenu

  class CLI < Thor

    desc 'build', 'Build the menu'
    method_option :filename, :aliases => '-f', :default => '', :desc => 'Save as filename.'
    method_option :verbose, :aliases => '-v', :default => false, :type => :boolean, :desc => 'Print helping output messages.'
    method_option :overwrite, :aliases => '-o', :default => true, :type => :boolean, :desc => 'Overwrite the app menu if exists.'
    def build
      FluxboxAppsMenu::Builder.new(options).create_menu
    end

    desc 'config', 'Make a local copy of the configuration file.'
    method_option :overwrite, :aliases => '-o', :default => false, :type => :boolean, :desc => 'Overwrite the config file if exists.'
    def config
      FluxboxAppsMenu::Builder.new(options).init_config
    end

    def help(arg = nil)
      if arg.nil?
        puts <<EOL

FluxboxAppsMenu v.#{FluxboxAppsMenu::VERSION} by Fabio Mucciante

Description:
  Generates a menu for Fluxbox containing the applications installed
  and visible in other DE menus.

  Customizations on the building process are achieved editing the
  "fluxbox_apps_menu.yaml" file copied under the "~/.fluxbox"
  folder by the "config" task.
  Watch the online page for more info:

    https://github.com/fabiomux/fluxbox_apps_menu/wiki

  The file containing the application tree will be created by 
  default to "~/.fluxbox/menu-apps" and can be included within the
  main menu adding the line:

    [include] (~/.fluxbox/menu-apps)

EOL
        super
      else
        super arg
      end
    end

#     default_task :build
  end

end 
