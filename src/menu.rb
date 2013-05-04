# Primary Author: Maxine Major
# menu.rb
# Lego_menu contents authored by Jason Fletcher
# This plugin adds items to the menu bar and
#   activates contained plugins.
# 
# Created 4/5/2013
# Last updated 5/4/2013

require 'sketchup.rb'
#require 'rules.rb'
require 'C:\Users\Maxine\Desktop\RuleBear\rb_requires.rb'

#Sketchup.send_action "showRubyPanel:"

#create_input

# Create new menu item under "Plugins"
rb_menu = UI.menu "Plugins"
rb_submenu = rb_menu.add_submenu("RuleBear")

# MAIN MENUS
  # Test Menu
  test_menu = rb_menu.add_submenu("Test")

  # Lego menu
  lego_menu = rb_submenu.add_submenu("Select a Lego")

  # Rules submenu
  rule_menu = rb_submenu.add_submenu("Select a Rule")
  
  # Create New Rule
  rule_create = rb_submenu.add_item("Create a Rule") {
    create_input  # method draws input box
  }

  # Rules > Delete Rule
  rule_delete = rb_submenu.add_item("Delete a Rule") {
    delete_rule  
  }



# LEGO RULES MENU 




  #LEGO SUBMENU
  
  lego_menu_2x2 = lego_menu.add_item("Select 2x2 Lego"){
    $selectedpiece = $piece2
    $piececolor = $piece2color
 
  }

  lego_menu_2x4 = lego_menu.add_item("Select 2x4 Lego"){
    $selectedpiece = $piece1
    $piececolor = $piece1color
  }

=begin # Below section nonfunctional for component Legos
  lego_menu_flip = lego_menu.add_item("Flip orientation"){
    $nodesL,$nodesW = $nodesW,$nodesL
    str = "Now placing " + $nodesL.to_s + "x" + $nodesW.to_s
    UI.messagebox(str)
  }
=end


 
# TEST MENU ITEMS

  test_instance = test_menu.add_item("Test Instance"){
    test_add_instance
  }

  print_stuff = test_menu.add_item("Print Selected Object IDs"){
    printstuff
  }

  #SAMPLE RULE. DELETE WHEN RULES ARE ADDED TO MENU
=begin
  # Menu: Rule 1
  rule1 = rule_menu.add_item("Place Lego at side") {
    rule_1   
  }
=end
