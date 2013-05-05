# rules_menu.rb
# Primary author: Maxine Major
# Created: 5/4/2013
# Last Modified: 5/5/2013
# This file contains the menu items for all user-created rules.

require 'sketchup.rb'
require 'C:\Program Files (x86)\Google\Google SketchUp 8\Plugins\menu.rb'

# add Rule1_menu
Rule1_menu = $rule_menu.add_item("Rule1"){
  set_active_rule( "Rule1" ) 
} # end Rule1_menu 

# add rule2_menu
rule2_menu = $rule_menu.add_item("Rule2"){
  set_active_rule( "rule2" ) 
} # end rule2_menu 

# add rule3_menu
rule3_menu = $rule_menu.add_item("Rule3"){
  set_active_rule( "rule3" ) 
} # end rule3_menu 

