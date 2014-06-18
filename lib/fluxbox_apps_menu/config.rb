require 'yaml'

module FluxboxAppsMenu
  class Config
    attr_reader :lang, :icon_paths, :filename, :banned_files, :app_paths, :icons, :terminal
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

      @banned_files = yaml[:banned_files]
      @icon_paths = yaml[:icon_paths]
      @app_paths = yaml[:app_paths] + [ ENV['HOME'] + '/.local/share/applications']
      @menu = yaml[:menu]
      @icons = yaml[:icons]
      @terminal = yaml[:terminal]

      @lang = ENV['LANG'].split('.')[0]
      @lang = { :short => @lang.split('_')[0], :long => @lang }
    end

    def expand_icon(app_name, icon_name)
      iname = @icons[app_name] unless app_name.nil?
      iname = icon_name        if iname.nil?

      return nil if iname.to_s.empty?
      return iname if iname.to_s.match('/') && File.exists?(iname)

      iname.gsub!(/\.png$/, '')

      @icon_paths.each do |p|
        return "#{p}/#{iname}.png" if File.exists?("#{p}/#{iname}.png")
      end

      return nil

    end
  end
end

