# Primary Author: Maxine Major
# menu.rb
# This plugin adds items to the menu bar and
#   activates contained plugins.
# Lego_menu contents authored by Jason Fletcher
# Created 4/5/2013
# Last updated 4/14/2013

require 'sketchup.rb'
require 'lego.rb'

# Create new menu item under "Plugins"
rb_menu = UI.menu "Plugins"
rb_submenu = rb_menu.add_submenu("RuleBear"){

}

# Rules submenu
rules_menu = rb_submenu.add_submenu("Rules")

  # Menu: Rule 1
  rule1 = rules_menu.add_item("Rule 1") {
    UI.messagebox "Rule 1 Activated"    
  }

  # Menu: Rule 2
  rule2 = rules_menu.add_item("Rule 2") {
    UI.messagebox "Rule 2 Activated"    
  }
    
  # Menu: Rule 3
  rule3 = rules_menu.add_item("Rule 3") {
    UI.messagebox "Rule 3 Activated"    
  }

# Lego submenu
lego_menu = rb_submenu.add_submenu("Legos")

  lego_menu_2x2 = lego_menu.add_item("Draw 2x2"){
    $nodesL = 2
    $nodesW = 2
  }

  lego_menu_2x4 = lego_menu.add_item("Draw 2x4"){
    $nodesL = 2
    $nodesW = 4
  }

  lego_menu_flip = lego_menu.add_item("Flip orientation"){
    $nodesL,$nodesW = $nodesW,$nodesL
    str = "Now placing " + $nodesL.to_s + "x" + $nodesW.to_s
    UI.messagebox(str)
}
  
