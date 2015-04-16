require 'fluxbox_apps_menu/version'
require 'fluxbox_apps_menu/config'
require 'fluxbox_apps_menu/menu'
require 'fluxbox_apps_menu/desktop_file'
require 'fluxbox_apps_menu/utils'

$VERBOSE = nil

module FluxboxAppsMenu

  class Builder

    def initialize(opts)
      #p opts; exit
      @filename = opts[:filename].to_s.empty? ? 'menu-apps' : opts[:filename]
      @silent = opts[:silent]
      @overwrite = opts[:overwrite]
      @cfg = FluxboxAppsMenu::Config.new
      @fmenu = FluxboxAppsMenu::Menu.new(@cfg)
    end

    def create_menu
      if @overwrite == false
        if File.exists?(File.expand_path("~/.fluxbox/#{@filename}"))
          puts "The file #{@filename} already exists!" unless @silent
          exit
        end
      end

      scan_app_folder
      text = @fmenu.render
      File.open(File.expand_path("~/.fluxbox/#{@filename}"), 'w') { |f| f.write(text) }
    end

    def init_config
      unless @overwrite
        if File.exists?(File.expand_path("~/.fluxbox/fluxbox_apps_menu.yaml"))
          puts '[Error] '.bold.red + "The file 'fluxbox_apps_menu.yaml' already exists in '#{File.expand_path('~/.fluxbox')}'" unless @silent
          exit
        end
      end
      FileUtils.copy(File.dirname(__FILE__) + '/fluxbox_apps_menu.yaml', File.expand_path('~/.fluxbox/'))
    end

    private 

    def scan_app_folder
      @cfg.app_paths.each do |d|

        Dir.glob(d + '/*.desktop') do |f|

          ini = DesktopFile.new(f, @cfg)

          next if ini.banned_file?

          name = ini.name

          if ini.hidden? 
            puts '[Hidden] '.bold.green + "The application \"#{name}\" is hidden" unless @silent
            next
          end

          cat = ini.categories
          if cat.nil?
            puts '[No Category] '.bold.red + "The application \"#{name}\" doesn't have any category" unless @silent
            next
          end

          submenu = @fmenu.assign_menu(cat, name)
          unless submenu.nil?
            icon = ini.icon
            if icon.nil?
              puts '[No Icon] '.bold.yellow + "The application \"#{name}\" doesn't have any icon" unless @silent
            end

            submenu[name] = @fmenu.item_exec(name, icon, ini.exec)
          else
            puts '[No mapped category] '.bold.red + "The application \"#{name}\" doesn't have any mapped category among: #{ini.categories.join(', ')}" unless @silent
          end
        end
      end
    end

  end
end
