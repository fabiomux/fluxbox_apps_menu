# frozen_string_literal: true

require "fluxbox_apps_menu/version"
require "fluxbox_apps_menu/config"
require "fluxbox_apps_menu/menu"
require "fluxbox_apps_menu/desktop_file"
require "fluxbox_apps_menu/utils"

module FluxboxAppsMenu
  #
  # Builder interface class.
  #
  class Builder
    def initialize(opts)
      @filename = opts[:filename].to_s.empty? ? "menu-apps" : opts[:filename]
      @verbose = opts[:verbose]
      @overwrite = opts[:overwrite]
      @cfg = FluxboxAppsMenu::Config.new
      @fmenu = FluxboxAppsMenu::Menu.new(@cfg)
    end

    def create_menu
      if !@overwrite && File.exist?(File.expand_path("~/.fluxbox/#{@filename}"))
        raise FileExists, "~/.fluxbox/#{@filename}"
      end

      scan_app_folder
      text = @fmenu.render
      File.write(File.expand_path("~/.fluxbox/#{@filename}"), text)
    end

    def init_config
      fpath = File.expand_path("~/.fluxbox/fluxbox_apps_menu.yaml")
      raise FileExists, "~/.fluxbox/fluxbox_apps_menu.yaml" if !@overwrite && File.exist?(fpath)

      FileUtils.copy("#{File.dirname(__FILE__)}/fluxbox_apps_menu.yaml", File.expand_path("~/.fluxbox/"))
    end

    private

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def scan_app_folder
      @cfg.app_paths.each do |d|
        Dir.glob(File.expand_path("#{d}/*.desktop")) do |f|
          Messages.examining f if @verbose
          ini = DesktopFile.new(f, @cfg)
          next if ini.banned_file?

          if ini.hidden?
            Messages.hidden(ini.name, f) if @verbose
            next
          end

          cat = ini.categories
          if cat.nil?
            Messages.no_category(ini.name, f) if @verbose
            next
          end
          submenu = @fmenu.assign_menu(cat, ini.name)
          raise NoMappedCategories, { name: ini.name, categories: ini.categories } if submenu.nil?

          submenu[ini.name] = MenuItem.new(label: ini.name, icon: ini.icon, command: ini.exec)
          if @verbose
            if ini.icon.nil?
              Messages.no_icon(ini.name, f)
            else
              Messages.ok(ini.name, f)
            end
          end
        end
      end

      Messages.help if @verbose
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity
  end
end
