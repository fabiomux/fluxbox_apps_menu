# frozen_string_literal: true

require "delegate"

module FluxboxAppsMenu
  #
  # Single menu item.
  #
  class MenuItem
    attr_accessor :label, :icon, :command, :level

    def initialize(args = {})
      @label = args[:label]       if args.key? :label
      @icon = args[:icon]         if args.key? :icon
      @command = args[:command]   if args.key? :command
      @level = args[:level]       if args.key? :level

      @rendered = []
      @level ||= 0
    end

    def wrap_item(str)
      "#{"  " * level}#{str}\n"
    end

    def <<(str)
      @rendered << str
      self
    end

    def render
      @rendered
    end
  end

  #
  # Separator menu item.
  #
  class SeparatorItem < SimpleDelegator
    def initialize(obj)
      super(obj)
      obj << wrap_item("[separator]")
    end
  end

  #
  # Executable menu item.
  #
  class ExecItem < SimpleDelegator
    def initialize(obj)
      super(obj)
      str = []
      str << "[exec]"
      str << "(#{label.gsub(/(?<!\\)\)/, '\)')})" unless label.to_s.empty?
      str << "{#{command}}" unless command.nil?
      str << "<#{icon}>" unless icon.to_s.empty?

      obj << wrap_item(str.join(" "))
    end
  end

  #
  # Start submenu item.
  #
  class StartSubmenuItem < SimpleDelegator
    def initialize(obj)
      super(obj)
      str = []
      str << "[submenu]"
      str << "(#{label.gsub(/(?<!\\)\)/, '\)')})" unless label.to_s.empty?
      str << "<#{icon}>" unless icon.to_s.empty?

      obj << wrap_item(str.join(" "))
    end
  end

  #
  # End submenu item.
  #
  class EndSubmenuItem < SimpleDelegator
    def initialize(obj)
      super(obj)
      obj << wrap_item("[end]")
    end
  end

  #
  # Menu rendering class.
  #
  class Menu
    def initialize(cfg = nil)
      @cfg = cfg.nil? ? FluxboxAppsMenu::Config.new : cfg
    end

    def assign_menu(cat, label)
      traverse_menu(@cfg.menu, cat.map(&:downcase), label)[0]
    end

    def render
      render_menu(@cfg.menu)
    end

    private

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def traverse_menu(menu, cat, label, selected_index = nil)
      # categories with smaller index are the favorites
      selected_index ||= 10_000
      selected = nil

      items = menu.select { |k, _v| k.instance_of?(String) }

      items.each do |key, info|
        next unless info.instance_of?(Hash)

        subitems = info.select { |k, _v| k.instance_of?(String) }

        # when a label is set the path has high priority
        return [info, 0] if info.key?(label)

        if info.key? :mandatory_categories
          info[:mandatory_categories] = info[:mandatory_categories].map(&:downcase)
          next unless (info[:mandatory_categories] & cat) == info[:mandatory_categories]
        end

        unless subitems.to_hash.empty?
          result, index = traverse_menu(subitems, cat, label, selected_index)
          unless result.nil?
            selected = result
            selected_index = index
          end
        end

        raise NoMenuCategories, key unless info.key? :categories

        categories = info[:categories].map { |s| s&.downcase }

        cat.each do |c|
          next unless categories.include?(c.strip)

          i = categories.index(c)
          if i < selected_index
            selected = info
            selected_index = i
          end
        end
      end

      [selected, selected_index]
    end

    def render_menu(menu, level = 0)
      text = ""
      # sort the items but let menu folders at the top
      menu.select { |k, _v| k.instance_of?(String) }
          .sort_by { |k, v| v.is_a?(MenuItem) ? k.downcase : "" }
          .each do |name, items|
            if items.instance_of? Hash
              icon = @cfg.expand_icon(nil, items[:icon])
              items = items.select { |k, _v| k.instance_of? String }
              subitems = render_menu(items, level + 1)

              text += render_subitem(level: level, label: name, icon: icon, subitems: subitems) unless subitems.empty?
            elsif items.is_a? MenuItem
              text += render_item(items, level)
            end
          end

      text
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    def render_subitem(args)
      i = MenuItem.new(level: args[:level], label: args[:label], icon: args[:icon])
      EndSubmenuItem.new(StartSubmenuItem.new(i) << args[:subitems]).render.join
    end

    def render_item(item, level)
      item.level = level
      ExecItem.new(item).render.join
    end
  end
end
