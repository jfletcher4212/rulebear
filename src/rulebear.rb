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
$pc_plugins_dir = "C:\Program Files (x86)\Google\Google SketchUp 8\Plugins"
$mac_plugins_dir = "/Library/Application Support/Google SketchUp 8/SketchUp/plugins"
$rb_filepath = "C:\\Users\\Maxine\\Desktop\\RuleBear"


#Notes:
# $selectedpiece is current piece
# Redefined variables for rule-making:
  $lego2x4 = $piece1    # $piece2 is 2x2 
  $lego2x2 = $piece2    # $piece1 is 2x4 
# $targetpiece = ??


# Objects a user may select for which to create rules
$rule_objs = Array.[]( "2x2Lego ", "2x4Lego " ) # object identifiers

#current active rule


