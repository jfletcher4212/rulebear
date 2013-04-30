# Primary Author: Maxine Major
# rules.rb
# This plugin defines 
#   rules affecting Lego class object placement
#   input boxes for rule creation
# 
# Created 4/16/2013
# Last updated 4/29/2013

require 'sketchup.rb'
require 'menu.rb'

# TEST
# UI.messagebox "piece 1 color = #{$piece1color}"

avail_objs = Array.[](1, 2, 3, 4, 5) #instead of nums, object names

#########
#       #
# RULES #
#       #
#########

# RULE 0: Select Lego
  # This rule is active with default Lego = 2x4
  # Alternate Lego selection accessible through menu 
 

# RULE 1: Place any Lego at base
def rule_1
  if 1
    # Lego is selected (Just a double-check. Default true)
    # 
  elsif 2 # any other object already exists =  fail
    # 
    # Error message
    #
  end

end


# RULE 2: Place 2x2 on 2x2
def rule_2

  current_obj = $piece1 
  target_obj = $piece2


  validate_obj( current_obj, target_obj )

=begin
  if( current obj is 2x2 and 
  if( target  obj is 2x2
  Then ok to place
  Else error message. Disable
=end

end


def placement_error
  

  
end

# better to enable placement when objects are verified.
#  
def validate_obj( obj1, obj2 )

  if(obj1.nil?)
    UI.messagebox "ERROR. current_obj  is nil."
    # disable placement here
    #
  elsif( obj2.nil? )
    UI.messagebox "ERROR. target_obj is nil."
    # disable placement here
    #
  else
    # Comment out this test block when all is functioning
    UI.messagebox "all is well"
  end

end



def create_input

  # DEFINE INPUT BOX
  # Note: drop down box for prompts that have pipe-delimited lists of options.
  prompts = [ # prompts are titles for each field
   "Rule Name", 
   "Class", 
   "Attribute", 
   "Value"
  ]
  # Default values for each field.   
    defaults = [  
     "rule_name", 
   "",    
   "",    
   ""   
    ]
  # Values for each field. "" allows user input value.  
    attributes_list = [
   "",# User input. Single-word value
   "",# List of valid Lego objects here
   "list|of|attributes|here",# List of attributes here
   "list|of|values|here",# List of values here
    ]

  # DRAW INPUT BOX
    createbox = UI.inputbox prompts,
  defaults,
  attributes_list,
  "Create a Rule"     # title of input box

  # Initialize variables with user input values
    $rulename = createbox[0]
    $classname = createbox[1]
    $attributename = createbox[2]
    $valuename = createbox[3]

    test_rule

end

# TEST USER INPUTS 
#  check to see if exact values used in another rule
def test_rule
  # TEST - USER INPUT VALUES
    UI.messagebox "rulename = #{$rulename}\n
  classname = #{$classname}\n
  attributename = #{$attributename}\n
  valuename = #{$valuename}"

  # verify values not already used in another rule
  # verify rulename not already in use
  # verify that for each rule in existence 
  #   that the current values are not ALL equal to 
  #   values in any other file.

end

# WRITE RULE TO FILE
=begin
def write_rule

  
end
=end




