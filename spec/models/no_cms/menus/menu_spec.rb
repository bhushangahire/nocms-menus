require 'spec_helper'

describe NoCms::Menus::Menu do

  it_behaves_like "model with required attributes", :no_cms_menus_menu, [:uid, :name]
  it_behaves_like "model with uniq attributes", :no_cms_menus_menu, [:uid]
  it_behaves_like "model with has many relationship", :no_cms_menus_menu, :no_cms_menus_menu_item, :menu_items, :menu


end
