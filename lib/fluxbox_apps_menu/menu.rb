require 'delegate'

module FluxboxAppsMenu

  class MenuItem
    attr_accessor :label, :icon, :command, :level

    def initialize(args = {})
      @label = args[:label]       if args.has_key? :label
      @icon = args[:icon]         if args.has_key? :icon
      @command = args[:command]   if args.has_key? :command
      @level = args[:level]       if args.has_key? :level

      @rendered = []
      @level ||= 0
    end

    def wrap_item(str)
      "#{'  ' * level}#{str}\n"
    end

    def <<(str)
      @rendered << str
      self
    end

    def render
      @rendered
    end
  end

  class SeparatorItem < SimpleDelegator

    def initialize(obj)
      super(obj)
      obj << wrap_item('[separator]')
    end
  end

  class ExecItem < SimpleDelegator

    def initialize(obj)
      super(obj)
      str = []
      str << '[exec]'
      str << "(#{label.gsub(/(?<!\\)\)/, '\)')})" unless label.to_s.empty?
      str << "{#{command}}" unless command.nil?
      str << "<#{icon}>" unless icon.to_s.empty?

      obj << wrap_item(str.join(' '))
    end
  end

  class StartSubmenuItem < SimpleDelegator

    def initialize(obj)
      super(obj)
      str = []
      str << '[submenu]'
      str << "(#{label.gsub(/(?<!\\)\)/, '\)')})" unless label.to_s.empty?
      str << "<#{icon}>" unless icon.to_s.empty?

      obj << wrap_item(str.join(' '))
    end
  end

  class EndSubmenuItem < SimpleDelegator

    def initialize(obj)
      super(obj)
      obj << wrap_item('[end]')
    end
  end

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

    def traverse_menu(menu, cat, label, selected_index = nil)
      #categories with smaller index are the favorites
      selected_index ||= 10000
      selected = nil

      items = menu.select { |k, v| k.class == String }

      items.each do |key, info|
        if info.class == Hash
          subitems = info.select { |k, v| k.class == String }

          # when a label is set the path has high priority
          return [info, 0] if info.has_key?(label)

          if info.has_key? :mandatory_categories
            info[:mandatory_categories] = info[:mandatory_categories].map(&:downcase)
            next unless (info[:mandatory_categories] & cat) == info[:mandatory_categories]
          end

          unless subitems.to_hash.empty?
            result, index = traverse_menu(subitems, cat, label, selected_index)
            selected, selected_index = result, index unless result.nil?
          end

          raise NoCategoriesError, key unless info.has_key? :categories

          categories = info[:categories].map { |s| s.downcase unless s.nil? }

          cat.each do |c|
            if categories.include?(c.strip)
              i = categories.index(c)
              if i < selected_index
                selected = info
                selected_index = i
              end
            end
          end

        end
      end

      [selected, selected_index]
    end

    def render_menu(menu, level = 0)
      text = ''

      # sort the items but let menu folders at the top
      menu = menu.select { |k, v| k.class == String }.sort_by { |k, v| (v.kind_of? MenuItem) ? k.downcase : '' }
      menu.each do |name, items|

        if items.class == Hash
          icon = items[:icon]
          items = items.select { |k, v| k.class == String }
          subitems = render_menu(items, level + 1)

          unless subitems.empty?
            text += begin
              i = MenuItem.new(:level => level, :label => name, :icon => @cfg.expand_icon(nil, icon))
              EndSubmenuItem.new(StartSubmenuItem.new(i) << subitems).render
            end.join
          end
        elsif items.kind_of? MenuItem
          text += begin
            items.level = level
            ExecItem.new(items).render
          end.join
        end
      end

      text
    end

  end
end
