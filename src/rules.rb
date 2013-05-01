# Primary Author: Maxine Major
# rules.rb
# This plugin defines 
#   rules affecting Lego class object placement
#   input boxes for rule creation
# 
# Created 4/16/2013
# Last updated 5/1/2013

require 'sketchup.rb'
require 'menu.rb'


#Notes:
# $selectedpiece is current piece
# Redefined variables for rule-making
  $lego2x4 = $piece1    # $piece2 is 2x2 
  $lego2x2 = $piece2    # $piece1 is 2x4 
# $targetpiece = ??





#########
#       #
# RULES #
#       #
#########

# RULE CLASS
class Rule
  
  # class level variables @@
  @@active_rule = "rule1"

  # RULE CLASS METHODS

  def initialize(rulename, curr, target, loc )
    @current_rule  = rulename #rename this
    @current_obj   = curr
    @target_obj    = target
    @placement_loc = loc
  end

  def check_rule_match(curr, target, loc)
    if( curr == @current_obj ) and ( target == @target_obj ) and ( loc = @placement_loc )
        UI.messagebox"Rule has been matched."
    elsif 3
      #error message for each criteria, stating which one is not met
    else 2
      # final error message
    end

  end

end



# RULE 0: Select Lego
  # This rule is active with default Lego = 2x4
  # Alternate Lego selection accessible through menu 
 

# RULE 1: Place any Lego at base
def rule_1
  UI.messagebox "Rule 1 Activated" 

  if 1# if any other object already exists
    # Error message
  else 
    # This object will be first object
    # place_base
    #   method enforces y = 0 for base placement
    #   then places object
  end

end


# RULE 2: Place 2x2 on 2x2
def rule_2

  if( $selectedpiece == $lego2x2 )
    UI.messagebox "selected piece is 2x2.\nOk to place."
  else
    UI.messagebox "Selected object is not a 2x2 Lego.\nCannot place."
    # do not allow placement!
  end

end


# RULE 3: Place 2x2 on 2x4 
def rule_3
  UI.messagebox "Rule 3 Activated"
end


# RULE 4: Place 2x4 on 2x2
def rule_4
  UI.messagebox "Rule 4 Activated" 

end


# RULE 5: Place 2x4 on 2x4
def rule_5
  UI.messagebox "Rule 5 Activated" 
end



def placement_error
  

  
end



##################
#                #
# USER INPUT BOX #
#                #
##################

# VALUES FOR USER TO SELECT FROM:
rule_objs = Array.[]( "a ", "b " ) #instead of nums, object names


# CREATE INPUT BOX
def create_input

  # DEFINE INPUT BOX
  # Note: drop down box for prompts that have pipe-delimited lists of options.
  prompts = [ # prompts are titles for each field
  "Rule Name",
  "Description",  #for comments in header file 
  "Object", 
  "Location"
  ]
  
  # Default values for each field.   
  defaults = [  
  "rule_name", 
  "describe rule here",    
  "#{rule_objs[1]}|#{rule_objs[2]}",    
  "top|side|corner"   
  ]
  
  # Values for each field. "" allows user input value.  
    attributes_list = [
   "",# User input. Single-word value
   "",# List of valid Lego objects here
   "",# List of attributes here
   "",# List of values here
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
  validate_rule

  # verify that for each rule in existence 
  #   that the current values are not ALL equal to 
  #   values in any other file.



end



######################
#                    #
# WRITE RULE TO FILE #
#                    #
######################
 

# CREATE NEW RULE
# this code adds all variables created by input box to end of rules file


def validate_rule

fname = "#{$rulename}.rb" # user input rulename will be rulename.rb
oktocreate = 0 # create rule? 0 = no / 1 = yes

#check for file existence/creation errors
if File.exist?(fname) # does the file we need exist?
  oktocreate = 0      # 
  UI.messagebox "Rule #{$rulename} exists. Cannot create rule."
else 
  oktocreate = 1
  File.open("#{fname}", 'w+')  #create file
  write_rule (fname)
end

end


# load file with user input rule criteria

def write_rule( fname )

  # open file with append - best to append rule as we parse input box
  accessfile = File.open("#{fname}", 'a')  

  accessfile.puts("stuff here")  #header info
  accessfile.puts("and then mnore stuff after stuff")  #header info

  # add a rule (append a rule to end of file)
  text3 = "I LOVE STUFF\n"
  text2 = "AND CATS"

  accessfile.puts("#{text3}")
  accessfile.puts("#{text2}")


  # close the file 
  accessfile.close
end


=begin
# RULE 1: Place any Lego at base
def rule_1
  UI.messagebox "Rule 1 Activated" 

  if 1# if any other object already exists
    # Error message
  else 
    # This object will be first object
    # place_base
    #   method enforces y = 0 for base placement
    #   then places object
  end

end
=end



  

# EDIT A RULE
# functionality not developed.


# DELETE A RULE
  # be conservative with this one





