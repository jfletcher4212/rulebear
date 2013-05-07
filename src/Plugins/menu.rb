# Primary Author: Maxine Major
# menu.rb
# Lego_menu contents authored by Jason Fletcher
# This plugin adds items to the menu bar and
#   activates contained plugins.
# 
# Created 4/5/2013
# Last updated 5/5/2013

require 'sketchup.rb'
#require 'rules.rb'
require 'C:\Users\Jason\Desktop\RuleBear\rules_menu.rb'


#create_input

# Create new menu item under "Plugins"
$rb_menu = UI.menu "Plugins"
if($rb_submenu.nil?)
  $rb_submenu = $rb_menu.add_submenu("RuleBear")
end

# MAIN MENUS
  # Test Menu
#  if($test_menu.nil?)
#    $test_menu = $rb_menu.add_submenu("Test")
#  end

  # Lego menu
  if($lego_menu.nil?)
    $lego_menu = $rb_submenu.add_submenu("Select a Lego")
  end

  # Rules submenu
  if($rule_menu.nil?)
    $rule_menu = $rb_submenu.add_submenu("Select a Rule")
  end
  
  # Shenanigans submenu
  if($shenanigans_menu.nil?)
    $shenanigans_menu = $rb_submenu.add_submenu("Shenanigans")
  end

  # Create New Rule
if( $rule_create.nil? )
  $rule_create = $rb_submenu.add_item("Create a Rule") {
    create_input  # method draws input box
  }
end

  # Rules > Delete Rule
if($rule_delete.nil?)
  $rule_delete = $rb_submenu.add_item("Delete a Rule") {
    delete_rule  
  }
end



# LEGO RULES MENU 




  #LEGO SUBMENU
if( $lego_menu_2x2.nil? )
  $lego_menu_2x2 = $lego_menu.add_item("Select 2x2 Lego"){
    $selectedpiece = $piece2
    $piececolor = $piece2color
 
  }
end

if($lego_menu_2x4.nil?)
  $lego_menu_2x4 = $lego_menu.add_item("Select 2x4 Lego"){
    $selectedpiece = $piece1
    $piececolor = $piece1color
  }
end

# SHENANIGANS MENU

  if($random_color_menu.nil?)
    $random_color_menu = $shenanigans_menu.add_item("Toggle Randomized Colors"){
      toggleColors
    }
  end
  if($random_piece_menu.nil?)
    $random_piece_menu = $shenanigans_menu.add_item("Place piece randomly on the last brick"){
      addPieceRandomly
    }
  end
  if($tower_menu.nil?)
    $tower_menu = $shenanigans_menu.add_item("Build a random tower"){
      placeXPieces
    }
  end
=begin # Below section nonfunctional for component Legos
  lego_menu_flip = lego_menu.add_item("Flip orientation"){
    $nodesL,$nodesW = $nodesW,$nodesL
    str = "Now placing " + $nodesL.to_s + "x" + $nodesW.to_s
    UI.messagebox(str)
  }
=end


 
# TEST MENU ITEMS FOR DEBUGGING

=begin
  test_instance = test_menu.add_item("Test Instance"){
    test_add_instance
  }

  print_stuff = test_menu.add_item("Print Selected Object IDs"){
    printstuff
  }
=end
  #SAMPLE RULE. DELETE WHEN RULES ARE ADDED TO MENU
=begin
  # Menu: Rule 1
  rule1 = rule_menu.add_item("Place Lego at side") {
    rule_1   
  }
=end
