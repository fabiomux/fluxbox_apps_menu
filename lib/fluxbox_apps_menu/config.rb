require 'yaml'

module FluxboxAppsMenu
  class Config
    attr_reader :lang, :icon_paths, :filename, :banned_files, :unhide_files, :app_paths, :icons, :terminal
    attr_accessor :menu

    def initialize
      if File.exists?(ENV['HOME'] + '/.fluxbox/fluxbox_apps_menu.yaml')
        @filename = ENV['HOME'] + '/.fluxbox/fluxbox_apps_menu.yaml'
      elsif File.exists?(ENV['HOME'] + '/.fluxbox_apps_menu.yaml')
        @filename = ENV['HOME'] + '/.fluxbox_apps_menu.yaml'
      elsif File.exists?('/etc/fluxbox_apps_menu.yaml')
        @filename = '/etc/fluxbox_apps_menu.yaml'
      else
        @filename = File.expand_path(File.dirname(__FILE__) + '/../fluxbox_apps_menu.yaml')
      end

      yaml = YAML.load_file(@filename)

      @banned_files = yaml[:banned_files] || []
      @unhide_files = yaml[:unhide_files] || []
      @icon_paths = yaml[:icon_paths] || []
      @app_paths = yaml[:app_paths] || []
      @menu = yaml[:menu] || {}
      @icons = yaml[:icons] || {}
      @terminal = yaml[:terminal] || 'xdg-terminal'

      @lang = ENV['LANG'].split('.')[0]
      @lang = { :short => @lang.split('_')[0], :long => @lang }
    end

    def expand_icon(app_name, icon_name)
      iname = @icons[app_name] unless app_name.nil?
      iname = icon_name        if iname.nil?

      return nil if iname.to_s.empty?
      return iname if iname.class == String && iname =~ /^\// && File.exists?(iname)

      iname = [iname] if iname.class == String

      iname.each do |i|
        i = File.basename(i, File.extname(i))

        @icon_paths.each do |p|
          return "#{p}/#{i}.png" if File.exists?("#{p}/#{i}.png")
        end
      end

      nil
    end
  end
end

