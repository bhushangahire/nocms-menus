module NoCms::Menus::MenuHelper

  def show_menu uid, options = {}
    menu = NoCms::Menus::Menu.find_by(uid: uid)
    return '' if menu.nil?

    options.reverse_merge! menu_class: 'menu'

    options[:active_menu_items] = menu.menu_items.active_for(menu_activation_params).map{|i| i.self_and_ancestors.pluck(:id)}.flatten.uniq
    options[:leaves_menu_items] ||= menu.menu_items.active_for(menu_activation_params).leaves.pluck(:id)

    content_tag(:ul, class: options[:menu_class]) do
      raw menu.menu_items.roots.no_drafts.includes(:translations).reorder(position: :asc).map{|r| show_submenu r, options }.join
    end.to_s

  end

  def show_submenu menu_item, options = {}

    options[:leaves_menu_items] ||= menu_item.menu.menu_items.active_for(menu_activation_params).leaves.pluck(:id)
    options[:active_menu_items] ||= menu_item.menu.menu_items.active_for(menu_activation_params).map{|i| i.self_and_ancestors.pluck(:id)}.flatten.uniq

    has_children = (!options[:depth] || (menu_item.depth < options[:depth]-1)) && # There's no depth option or we are below that depth AND
      !options[:leaves_menu_items].include?(menu_item.id) # This menu item is not a leaf

    options.reverse_merge! current_class: 'active', with_children_class: 'has-children'

    item_classes = ['menu_item']
    item_classes << options[:current_class] if options[:active_menu_items].include?(menu_item.id)
    item_classes << options[:with_children_class] if has_children

    content_tag(:li, class: item_classes.join(' ')) do
      # If this menu item points to a route in other engine we need that engines route set
      menu_item_route_set = menu_item.route_set.nil? ? main_app : send(menu_item.route_set)
      # Now we get the url_for info and if it's a hash then add the :only_path option
      url_info =  menu_item.url_for
      url_info[:only_path] = true if url_info.is_a? Hash
      url_info = { object: url_info, only_path: true } if

      # When url_info is an ActiveRecord object we have to use polymorphic_path instead of url_for
      path = url_info.is_a?(ActiveRecord::Base) ? menu_item_route_set.polymorphic_path(url_info) :  menu_item_route_set.url_for(url_info)

      # And finally get the link
      content = link_to menu_item.name, path
      content += show_children_submenu(menu_item, options) if has_children
      content
    end
  end

  def show_children_submenu menu_item, options = {}
    options = options.dup

    options[:leaves_menu_items] ||= menu_item.menu.menu_items.active_for(menu_activation_params).leaves.pluck(:id)
    options[:active_menu_items] ||= menu_item.menu.menu_items.active_for(menu_activation_params).map{|i| i.self_and_ancestors.pluck(:id)}.flatten.uniq

    has_children = (!options[:depth] || (menu_item.depth < options[:depth]-1)) && # There's no depth option or we are below that depth AND
      !options[:leaves_menu_items].include?(menu_item.id) # This menu item is not a leaf

    options.reverse_merge! current_class: 'active', with_children_class: 'has-children'

    submenu_id = options.delete :submenu_id
    if options[:submenu_class].is_a? Array
      options[:submenu_class] = options[:submenu_class].dup
      submenu_class = options[:submenu_class].shift
    else
      submenu_class = options.delete :submenu_class
    end

    content_tag(:ul, id: submenu_id, class: submenu_class) do
      raw menu_item.children.no_drafts.includes(:translations).reorder(position: :asc).map{|c| show_submenu c, options }.join
    end if has_children
  end

  def menu_activation_params
    {
      object: menu_object,
      action: "#{params[:controller]}##{params[:action]}"
    }
  end

  def menu_object
    return @menu_object unless @menu_object.nil?
    @menu_object ||= instance_variable_get("@#{menu_object_name}")
  end

  def menu_object_name
    controller.controller_name.singularize
  end

  def current_menu_items_in_menu menu
    menu = NoCms::Menus::Menu.find_by(uid: menu) if menu.is_a? String
    return NoCms::Menus::MenuItem.none if menu.nil?
    menu.menu_items.active_for menu_activation_params
  end

  def current_roots_in_menu menu
    menu = NoCms::Menus::Menu.find_by(uid: menu) if menu.is_a? String
    return NoCms::Menus::MenuItem.none if menu.nil?
    current_menu_items_in_menu_at_level menu, 1
  end

  def current_menu_items_in_menu_at_level menu, level
    menu = NoCms::Menus::Menu.find_by(uid: menu) if menu.is_a? String
    return NoCms::Menus::MenuItem.none if menu.nil?
    current_menu_items_in_menu(menu).map{|c| c.self_and_ancestors.where(depth: level-1) }.flatten
  end
end
