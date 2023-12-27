# frozen_string_literal: true

require "yaml"

module FluxboxAppsMenu
  #
  # Configurations handling.
  #
  class Config
    attr_reader :lang, :icon_paths, :filename, :banned_files, :unhide_files, :app_paths, :icons, :terminal
    attr_accessor :menu

    def initialize
      @filename = config_file
      load_config(@filename)

      @lang = ENV["LANG"].split(".")[0]
      @lang = { short: @lang.split("_")[0], long: @lang }
    end

    def expand_icon(app_name, icon_name)
      iname = @icons[app_name] unless app_name.nil?
      iname = icon_name        if iname.nil?
      return nil if iname.to_s.empty?
      return iname if iname.instance_of?(String) && File.exist?(iname)
      return icon_file(iname) if iname.instance_of?(String)

      loop_icons(iname)
    end

    private

    # rubocop:disable Metrics/CyclomaticComplexity
    def load_config(filename)
      yaml = YAML.load_file(filename)
      @banned_files = yaml[:banned_files] || []
      @unhide_files = yaml[:unhide_files] || []
      @icon_paths = yaml[:icon_paths] || []
      @app_paths = yaml[:app_paths] || []
      @menu = yaml[:menu] || {}
      @icons = yaml[:icons] || {}
      @terminal = yaml[:terminal] || "xdg-terminal"
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def loop_icons(icons)
      icons.each do |i|
        icon = icon_file(i)
        return icon unless icon.nil?
      end
      nil
    end

    def icon_file(name)
      i = File.basename(name, File.extname(name))
      @icon_paths.each do |p|
        return "#{p}/#{i}.png" if File.exist?("#{p}/#{i}.png")
      end
      nil
    end

    def config_file
      filename = "#{Dir.home}/.fluxbox/fluxbox_apps_menu.yaml"
      return filename if File.exist? filename

      filename = "#{Dir.home}/.fluxbox_apps_menu.yaml"
      return filename if File.exist? filename

      filename = "/etc/fluxbox_apps_menu.yaml"
      return filename if File.exist? filename

      File.expand_path("#{__dir__}/../fluxbox_apps_menu.yaml")
    end
  end
end
