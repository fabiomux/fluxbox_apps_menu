module FluxboxAppsMenu

  class ::String
    def black;          "\033[30m#{self}\033[0m" end
    def red;            "\033[31m#{self}\033[0m" end
    def green;          "\033[32m#{self}\033[0m" end
    def yellow;         "\033[33m#{self}\033[0m" end
    def blue;           "\033[34m#{self}\033[0m" end
    def magenta;        "\033[35m#{self}\033[0m" end
    def cyan;           "\033[36m#{self}\033[0m" end
    def gray;           "\033[37m#{self}\033[0m" end
    def bg_black;       "\033[40m#{self}\0330m"  end
    def bg_red;         "\033[41m#{self}\033[0m" end
    def bg_green;       "\033[42m#{self}\033[0m" end
    def bg_brown;       "\033[43m#{self}\033[0m" end
    def bg_blue;        "\033[44m#{self}\033[0m" end
    def bg_magenta;     "\033[45m#{self}\033[0m" end
    def bg_cyan;        "\033[46m#{self}\033[0m" end
    def bg_gray;        "\033[47m#{self}\033[0m" end
    def bold;           "\033[1m#{self}\033[22m" end
    def reverse_color;  "\033[7m#{self}\033[27m" end
    def cr;             "\r#{self}" end
    def clean;          "\e[K#{self}" end
    def new_line;       "\n#{self}" end
  end

  class Messages
    def self.error(e)
      if e.class.to_s =~ /^FluxboxAppsMenu/
        STDERR.puts e.message.new_line
      else
        STDERR.puts 'Error! '.bold.red.new_line + e.message
      end
    end

    def self.examining(filename)
      print '[-] '.bold.blue + "Examining #{filename}... "
      STDOUT.flush
      sleep 0.01
    end

    def self.hidden(name, filename)
      puts '[H] '.bold.gray.clean.cr + "\"#{name}\" (#{filename})"
    end

    def self.no_icon(name, filename)
      puts '[I] '.bold.yellow.clean.cr + "\"#{name}\" (#{filename})"
    end

    def self.ok(name, filename)
      puts '[V]'.bold.green.clean.cr + " \"#{name}\" (#{filename})"
    end

    def self.no_category(name, filename)
      puts '[C] '.bold.red.clean.cr + "\"#{name}\" (#{filename})" 
    end

    def self.help
      puts ''
      puts 'Quick Help:'
      puts ''
      puts '  [V]: Everything is ok'.bold.green
      puts '  [H]: Hidden app'.bold.gray
      puts '  [I]: App without icon'.bold.yellow
      puts '  [C]: App without categories'.bold.red
      puts ''
    end
  end

  class NoMenuCategories < StandardError
    def initialize(item)
      super 'Error! '.bold.red + "The menu item \"#{item}\" doesn't have any category, fix it to \"fluxbox_apps_menu.yaml\""
    end
  end

  class NoMappedCategories < StandardError
    def initialize(params)
      super 'Error! '.bold.red + "The item \"#{params[:name]}\" doesn't have any mapped category among #{params[:categories].join(', ')}, fix it to \"fluxbox_apps_menu.yaml\""
    end
  end

  class FileExists < StandardError
    def initialize(filename)
      super 'Error! '.bold.red + "The file #{filename} already exists, use the --overwrite switch to avoid this error."
    end
  end

  class Interruption < StandardError
    def initialize
      super '[X] Ok ok... Exiting!'.bold.blue
    end
  end

  Signal.trap('INT') { raise Interruption }

  Signal.trap('TERM') { raise Interruption }
end
