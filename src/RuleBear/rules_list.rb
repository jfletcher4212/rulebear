# rules_list.rb
# Primary author: Maxine Major
# Created: 5/4/2013
# Last Modified: 5/5/2013
# This file contains the global array from which RuleBear gets its rules.
# User inputs add array items to this list.

require 'sketchup.rb'

#UI.messagebox "rules_list.rb is alive and working!"

$rules_list= Array.[]         # list of all rules. 


$rules_list << ["Rule1",
                "this is a rule",
                "2x2", 
                "2x4",
                "side" ]
                    
$rules_list << ["rule2",
                "this is another rule",
                "2x2", 
                "2x2",
                "corner" ]
                    
$rules_list << ["rule3",
                "another rule, again!",
                "2x4", 
                "2x4",
                "top" ]
                    
