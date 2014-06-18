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
      @ini['Desktop Entry']['NoDisplay'] == 'true' 
    end

    def banned_file?
      @cfg.banned_files.each { |r| return true if @filename =~ Regexp.new(r) }
      false
    end

    def icon
=begin      
      iname = @cfg.icons[name(false)]
      iname = @ini['Desktop Entry']['Icon'] if iname.nil?

      return nil if iname.to_s.empty?
      return iname if iname.to_s.match('/') && File.exists?(iname)

      iname.gsub!(/\.png$/, '')

      @cfg.icon_paths.each do |p|
        return "#{p}/#{iname}.png" if File.exists?("#{p}/#{iname}.png")
      end
      return nil
=end
      @cfg.expand_icon(name(false), @ini['Desktop Entry']['Icon'])
    end

    def terminal?
      @ini['Desktop Entry']['Terminal'] == 'true'
    end

    def categories
      cat = @ini['Desktop Entry']['Categories']
      cat.split(';') unless cat.nil?
    end

    def exec
      com = @ini['Desktop Entry']['Exec'].gsub('%c', name).gsub('%F', '')
        .gsub('%i', '').gsub('%U', '').gsub('%f', '').gsub('%m', '')
        .gsub('%u', '').gsub(/[ ]{2,}/, ' ').gsub(/\ }/, '}')

      terminal? ? @cfg.terminal + ' ' + com : com
    end
  end

end
