# Primary Author: Maxine Major
# rules.rb
#
# This plugin defines:
#   list of rules and criteria affecting Lego class object placement
#   input boxes for rule creation
#   array containing rules
#   active rule and rule comparison methods
#
# Methods include:
#   create_input  - a user input box to create a rule
#   test_input    - ensure input values valid for creating a rule
#   add_rule_to_list     - 
#   set_active_rule
#
# Created 4/16/2013
# Last updated 5/5/2013

require 'sketchup.rb'


# CREATE INPUT BOX -------------------------------------------------- 
def create_input


  # DEFINE INPUT BOX
  # Note: drop down box for prompts that have pipe-delimited lists of options.
  prompts = [ # prompts are titles for each field
  "Rule Name (no spaces)",
  "Rule Description",  #for comments in header file 
  "Object to Place", 
  "Base Object",
  "Location"
  ]
  
  # Default inputs for each field. Most will be drop-down  
  defaults = [  
    "rulename", # need to make this secure by checking for allowable values
    "",         # Description
    "",         # Placing object
    "",         # Base object
    ""          # Placement location
  ]

  # Possible values for each field. Empty "" allows user input value.  
  attributes_list = [
    "",                                  # User input. Single-word value
    "",                                  # User input. Phrase
    "#{$rule_objs[0]}|#{$rule_objs[1]}", # Drop-down of placeable objects
    "#{$rule_objs[0]}|#{$rule_objs[1]}", # Drop-down of base objects
    "#{$rule_locs[0]}|#{$rule_locs[1]}|#{$rule_locs[2]}"                    # Drop-down of placement locations
    ] 


  # DRAW INPUT BOX
  ruleinputbox = UI.inputbox prompts, 
                             defaults, 
                             attributes_list, 
                             "Create a Rule"   # title of input box

  #test input box creation
  if (ruleinputbox)                     # If box creation is successful
    create_rule( ruleinputbox )  # turn user inputs into variables

  else
    UI.messagebox "Error: Create a rule could not be launched."
   
  end

end

# PROCESS NEW RULE -------------------------------------------------- 

# Initialize variables with user input values from input box
def create_rule( ruleinputbox )

  # initialize rule variables
    $rulename    = ruleinputbox[0]
    $ruledesc    = ruleinputbox[1]
    $ruleobj     = ruleinputbox[2]
    $rulebaseobj = ruleinputbox[3]
    $ruleloc     = ruleinputbox[4]

  
  if( $rulename == "" )
    UI.messagebox "Rule Name is invalid.\nCould not create rule."
   
 # elsif # can find rulename in array
=begin
  else  # print input values for testing purposes
    UI.messagebox "Create rule: #{$rulename}\nDescription: #{$ruledesc}\nObject: #{$ruleobj}\nTarget Obj: #{},Location: #{$ruleloc}"
=end

  end

  # TEST RULE INPUTS: Ensure that at either object, target obj, or location 
    # has been selected. If none of these are selected, 
    # then we have no criteria for establishing a rule.

  if( $ruleobj == "" and $rulebaseobj == "" and $ruleloc =="" )
    UI.messagebox "ERROR: no criteria selected with which to create a rule"

  else
    #UI.messagebox "We have enough criteria to make a rule"
    
    add_rule_to_array #send rule to get either created or discarded

  end

end


# ----- ADD RULE TO RULES ARRAY -----



# WRITE RULE TO FILE with user input rule criteria
def add_rule_to_array

  # open file
  unless ( File.exist?( File.join( $rb_filepath, "rules_list.rb") ) ) 
      UI.messagebox "Apparently the file rules_list.rb doesn't exist."
      # (Future development: If it doesnt exist, make it.)

  else # File is good. We may write to file

    accessfile = File.open( File.join( $rb_filepath, "rules_list.rb"), 'a' )
    accessfile.puts( 
                    "\$rules_list \<\< \[\"#{$rulename}\",
                \"#{$ruledesc}\",
                \"#{$ruleobj}\", 
                \"#{$rulebaseobj}\",
                \"#{$ruleloc}\" \]
                    " )  

    accessfile.close

  end

  
  add_rule_to_menu
  
end


def add_rule_to_menu
  
  # open file
  unless ( File.exist?( File.join( $rb_filepath, "rules_menu.rb") ) ) 
      UI.messagebox "Apparently the file rules_menu.rb doesn't exist."
      # (Future development: If it doesnt exist, make it.)

  else # File is good. We may write to file

    accessfile = File.open( File.join( $rb_filepath, "rules_menu.rb"), 'a' )
    

  # variables for menu creation    
    menuname =  "#{$rulename}"+"_menu"
    menudesc = "#{$rulename}".capitalize
    
  # add rule to menu

    accessfile.puts("\# add #{menuname}") 
    accessfile.puts("#{menuname} = $rule_menu.add_item\(\"#{menudesc}\"\)\{")  
    accessfile.puts("  set_active_rule\( \"#{$rulename}\" \) ")
    accessfile.puts("\} \# end #{menuname} " )  # add --> end for future rule deletion 
    accessfile.puts( "" )   
    accessfile.close

    UI.messagebox "Rule \"#{$rulename}\"  has been added!"

  end

end


def set_active_rule( selectrule )

  # selectrule is a string name of active rule
  # We need to 
  #   a) find that location in the array
  #   b) initialize our comparison variables with that list's values
  #      This sets selectrule's items as ones to compare against

  # search array for $rules_list[i][0] == "#{selectrule}"

  $rules_list.each do |ruleval|
    if( ruleval[0] == "#{selectrule}" ) 
    
    #initialize global active vars
      $active_rule    = ruleval[0]
      $active_desc    = ruleval[1]
      $active_obj     = ruleval[2]
      $active_target  = ruleval[3]
      $active_loc     = ruleval[4]   
    
      if( $active_obj == "2x4" )
        $active_piece = $piece1 # $piece1 is 2x4
      elsif( $active_obj == "2x2" )
        $active_piece = $piece2 # $piece2 is 2x2
      else
        UI.messagebox "Error: Active piece is undefined."
      end

      UI.messagebox "Active rule is #{$active_rule}.capitalize, #{$active_desc}.capitalize.
      Placement object:   #{$active_obj}
      Target object:      #{$active_target}
      Placement location: #{$active_loc}"
    end

  end

end



# EDIT A RULE
# functionality not developed.


# DELETE A RULE
  #currently does not delete rule from requires file

def delete_rule

  #input box for rule to delete
  
  prompts = ["Name of Rule to Delete: "]
  defaults = ["rulename"] 
  attributes_list = [""]

  deletebox = UI.inputbox prompts, 
                          defaults, 
                          attributes_list, 
                          "Delete a Rule"   # title of input box

  #test input box creation
  if (deletebox)                     # If box creation is successful
    deleterule = "#{deletebox[0]}"
    UI.messagebox "will be deleting #{deleterule}"
  else
    UI.messagebox "Error: Unable to delete rule."
   
  end

  #verify if rule deletion is necessary
  
  # delete file
  
    # find rule in $rules_array and delete _____________________________#

end
