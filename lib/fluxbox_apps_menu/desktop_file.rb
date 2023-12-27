# frozen_string_literal: true

require "iniparse"

module FluxboxAppsMenu
  #
  # Desktop file parsing.
  #
  class DesktopFile
    def initialize(filename, cfg = nil)
      @ini = IniParse.parse(File.read(filename))
      @cfg = cfg.nil? ? FluxboxAppsMenu::Config.new : cfg
      @filename = filename
    end

    def name(lang = nil)
      lang ||= true
      if lang
        name = @ini["Desktop Entry"]["Name[#{@cfg.lang[:short]}]"]
        name = @ini["Desktop Entry"]["Name[#{@cfg.lang[:long]}]"] if name.nil?
      end

      name = @ini["Desktop Entry"]["Name"] if name.nil?
      name
    end

    def hidden?
      @cfg.unhide_files.each { |r| return false if @filename =~ Regexp.new(r) }
      %w[true 1].include? @ini["Desktop Entry"]["NoDisplay"].to_s
    end

    def banned_file?
      @cfg.banned_files.each { |r| return true if @filename =~ Regexp.new(r) }
      false
    end

    def icon
      @cfg.expand_icon(name(false), @ini["Desktop Entry"]["Icon"])
    end

    def terminal?
      %w[true 1].include? @ini["Desktop Entry"]["Terminal"].to_s
    end

    def categories
      cat = @ini["Desktop Entry"]["Categories"]
      cat&.split(";")
    end

    def exec
      com = @ini["Desktop Entry"]["Exec"].to_s
                                         .gsub(/((?:"){,1})%c\1/, "\\1#{name}\\1")
                                         .gsub(/((?:"){,1})(%F|%i|%U|%f|%m|%u)\1/, "")
                                         .gsub(/ {2,}/, " ").gsub(/\ }/, "}").strip

      terminal? ? "#{@cfg.terminal} #{com}" : com
    end
  end
end
