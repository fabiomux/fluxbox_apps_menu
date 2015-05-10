require 'inifile'
#require 'fluxbox_apps_menu/config'
module FluxboxAppsMenu

  class DesktopFile

    def initialize(filename, cfg = nil)
      @ini = IniFile.new(:filename => filename, :comment => '#', :encoding => 'UTF-8')
      @cfg = cfg.nil? ? FluxboxAppsMenu::Config.new : cfg
      @filename = filename
    end

    def name(lang = true)
      if lang
        name = @ini['Desktop Entry']["Name[#{@cfg.lang[:short]}]"]
        name = @ini['Desktop Entry']["Name[#{@cfg.lang[:long]}]"] if name.nil?
      end

      name = @ini['Desktop Entry']['Name'] if name.nil?

      name
    end

    def hidden?
       %w(true 1).include? @ini['Desktop Entry']['NoDisplay'].to_s
    end

    def banned_file?
      @cfg.banned_files.each { |r| return true if @filename =~ Regexp.new(r) }
      false
    end

    def icon
      @cfg.expand_icon(name(false), @ini['Desktop Entry']['Icon'])
    end

    def terminal?
      %w(true 1).include? @ini['Desktop Entry']['Terminal'].to_s
    end

    def categories
      cat = @ini['Desktop Entry']['Categories']
      cat.split(';') unless cat.nil?
    end

    def exec
      com = @ini['Desktop Entry']['Exec'].to_s.gsub('%c', name).gsub('%F', '')
        .gsub('%i', '').gsub('%U', '').gsub('%f', '').gsub('%m', '')
        .gsub('%u', '').gsub(/[ ]{2,}/, ' ').gsub(/\ }/, '}').strip

      terminal? ? @cfg.terminal + ' ' + com : com
    end
  end

end
