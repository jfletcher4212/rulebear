# rulebear.rb
# Primary author: Maxine Major
# Created: 5/4/2013
# Modified: 5/4/2013
# 
# This file contains primary RuleBear globals and
#   active rule information.
#

require 'sketchup.rb'


Sketchup.send_action "showRubyPanel:"

# global path variables
$pc_plugins_dir = "C:\\Program Files (x86)\\Google\\Google SketchUp 8\\Plugins"
$mac_plugins_dir = "/Library/Application Support/Google SketchUp 8/SketchUp/plugins"
$rb_filepath = "C:\\Users\\Maxine\\Desktop\\RuleBear"


require 'C:\Users\Maxine\Desktop\RuleBear\rules_list.rb'
require 'C:\Users\Maxine\Desktop\RuleBear\rules_menu.rb'



#Notes:
# $selectedpiece is current piece
# Redefined variables for rule-making:
  $lego2x4 = $piece1   
  $lego2x2 = $piece2   




# Items a user may select for which to create rules
$rule_objs = Array.[]( "2x2", "2x4" ) # object identifiers
$rule_locs = Array.[]("top", "side", "corner")

# ACTIVE RULES STORED IN RULES_LIST.RB IN RULEBEAR FOLDER ON DESKTOP 
# $rules_list[] 
#
# # active rule properties initialized in set_active_rule method
# $active_rule    = ruleval[0]
# $active_desc    = ruleval[1]
# $active_obj     = ruleval[2]
# $active_target  = ruleval[3]
# $active_loc     = ruleval[4] 



# functions necessary for checking:
  # check that rulename is not duplicated
  # can check to make sure that $rules_array[][1-3] are not duplicated
  # when inserting a new rule (after validation), add to menu

