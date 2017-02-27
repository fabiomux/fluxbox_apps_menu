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

        Dir.glob(File.expand_path(d + '/*.desktop')) do |f|

          ini = DesktopFile.new(f, @cfg)

          next if ini.banned_file?

          name = ini.name

          if ini.hidden? 
            puts '[H] '.bold.gray + "\"#{name}\" (#{f})" unless @silent
            next
          end

          cat = ini.categories
          if cat.nil?
            puts '[C] '.bold.red + "\"#{name}\" (#{f})" unless @silent
            next
          end

          begin
            submenu = @fmenu.assign_menu(cat, name)
          rescue NoCategoriesError => e
            puts '[C] '.bold.red + "The \"#{e.message}\" menu item doesn't have any category, fix it to your \"fluxbox_menu_apps.yaml\""
            exit
          end

          unless submenu.nil?
            icon = ini.icon
            if icon.nil?
              puts '[I] '.bold.yellow + "\"#{name}\" (#{f})" unless @silent
            end

            submenu[name] = @fmenu.item_exec(name, icon, ini.exec)
          else
            puts '[C] '.bold.red + "\"#{name}\" doesn't have any mapped category among: #{ini.categories.join(', ')}" unless @silent
          end
        end
      end

      unless @silent
        puts ''
        puts 'Legenda:'
        puts ''
        puts '  [H]: Hidden app'.bold.gray
        puts '  [I]: App without icon'.bold.yellow
        puts '  [C]: App without categories'.bold.red
        puts ''
      end
    end

  end
end
