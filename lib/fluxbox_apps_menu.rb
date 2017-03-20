require 'fluxbox_apps_menu/version'
require 'fluxbox_apps_menu/config'
require 'fluxbox_apps_menu/menu'
require 'fluxbox_apps_menu/desktop_file'
require 'fluxbox_apps_menu/utils'

module FluxboxAppsMenu

  class Builder

    def initialize(opts)
      @filename = opts[:filename].to_s.empty? ? 'menu-apps' : opts[:filename]
      @verbose = opts[:verbose]
      @overwrite = opts[:overwrite]
      @cfg = FluxboxAppsMenu::Config.new
      @fmenu = FluxboxAppsMenu::Menu.new(@cfg)
    end

    def create_menu
      unless @overwrite
        raise FileExists, "~/.fluxbox/#{@filename}" if File.exists?(File.expand_path("~/.fluxbox/#{@filename}"))
      end

      scan_app_folder
      text = @fmenu.render
      File.open(File.expand_path("~/.fluxbox/#{@filename}"), 'w') { |f| f.write(text) }
    end

    def init_config
      unless @overwrite
        raise FileExists, '~/.fluxbox/fluxbox_apps_menu.yaml' if File.exists?(File.expand_path("~/.fluxbox/fluxbox_apps_menu.yaml"))
      end
      FileUtils.copy(File.dirname(__FILE__) + '/fluxbox_apps_menu.yaml', File.expand_path('~/.fluxbox/'))
    end

    private 

    def scan_app_folder
      @cfg.app_paths.each do |d|

        Dir.glob(File.expand_path(d + '/*.desktop')) do |f|

          Messages.examining f if @verbose

          ini = DesktopFile.new(f, @cfg)

          next if ini.banned_file?

          name = ini.name

          if ini.hidden? 
            Messages.hidden(name, f) if @verbose
            next
          end

          cat = ini.categories
          if cat.nil?
            Messages.no_category(name, f) if @verbose
            next
          end

          submenu = @fmenu.assign_menu(cat, name)

          raise NoMappedCategories, {:name => name, :categories => ini.categories} if submenu.nil?

          icon = ini.icon

          submenu[name] = MenuItem.new(:label => name, :icon  => icon, :command => ini.exec)

          if @verbose 
            if icon.nil?
              Messages.no_icon(name, f)
            else
              Messages.ok(name, f)
            end
          end
        end
      end

      Messages.help if @verbose
    end

  end
end
