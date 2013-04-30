# Primary Author: Maxine Major
# menu.rb
# Lego_menu contents authored by Jason Fletcher
# This plugin adds items to the menu bar and
#   activates contained plugins.
# 
# Created 4/5/2013
# Last updated 4/29/2013

require 'sketchup.rb'


# Create new menu item under "Plugins"
rb_menu = UI.menu "Plugins"
rb_submenu = rb_menu.add_submenu("RuleBear")

# MAIN MENUS

# Test Menu
test_menu = rb_menu.add_submenu("Test")


# Rules submenu
rule_menu = rb_submenu.add_submenu("Rules")
  

# Rule Maintenance submenu
rule_maint_menu = rb_submenu.add_submenu("Rule Maintenance")



# RULES MAINTENANCE SUBMENU OPTIONS

  # Rules > Create New Rule
  rule_create = rule_maint_menu.add_item("Create a Rule") {
  create_input  # method draws input box
  }

  # Rules > Edit Rule 
  # Rule Creation box with fields populated appears.  
  rule_edit = rule_maint_menu.add_item("Edit a Rule") {
    UI.messagebox "Rule editing nonfunctional at this time."
  }

  # Rules > Delete Rule
  rule_delete = rule_maint_menu.add_item("Delete a Rule") {
    UI.messagebox "Rule deletion here"    
  }


# LEGO RULES MENU 

  # LEGO MENU

  lego_menu = rule_menu.add_submenu("Rule 0: Select Lego")


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

  # PLACEMENT RULES MENU

  # Menu: Rule 1
  rule1 = rule_menu.add_item("Rule 1: Place base Lego") {
    UI.messagebox "Rule 1 Activated"    
  }

  # Menu: Rule 2
  rule2 = rule_menu.add_item("Rule 2: Place 2x2 on 2x2") {
    UI.messagebox "Rule 2 Activated" 
    rule_2   
  }
    
  # Menu: Rule 3
  rule3 = rule_menu.add_item("Rule 3: Place 2x2 on 2x4") {
    UI.messagebox "Rule 3 Activated"    
  }
 
  # Menu: Rule 4
  rule4 = rule_menu.add_item("Rule 4: Place 2x4 on 2x2") {
    UI.messagebox "Rule 4 Activated"    
  }

  # Menu: Rule 5
  rule5 = rule_menu.add_item("Rule 5: Place 2x4 on 2x4") {
    UI.messagebox "Rule 5 Activated"    
  }

 
# TEST MENU ITEMS

  test_instance = test_menu.add_item("Test Instance"){
  test_add_instance
  }

  print_stuff = test_menu.add_item("Print Selected Object IDs"){
  printstuff
  }
