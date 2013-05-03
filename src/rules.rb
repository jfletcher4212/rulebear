# Primary Author: Maxine Major
# rules.rb
# This plugin defines 
#   rules affecting Lego class object placement
#   input boxes for rule creation
# 
# Created 4/16/2013
# Last updated 5/2/2013

require 'sketchup.rb'

# Sketchup.send_action "showRubyPanel"

#Notes:
# $selectedpiece is current piece
# Redefined variables for rule-making
  $lego2x4 = $piece1    # $piece2 is 2x2 
  $lego2x2 = $piece2    # $piece1 is 2x4 
# $targetpiece = ??


# Objects a user may select for which to create rules
$rule_objs = Array.[]( "2x2Lego ", "2x4Lego " ) # object identifiers



# ----- USER INPUT BOX -----

# CREATE INPUT BOX
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
    "top|side|corner"                    # Drop-down of placement locations
    ] 


  # DRAW INPUT BOX
  ruleinputbox = UI.inputbox prompts, 
                             defaults, 
                             attributes_list, 
                             "Create a Rule"   # title of input box

  # Initialize variables with user input values
    $rulename    = ruleinputbox[0]
    $ruledesc    = ruleinputbox[1]
    $ruleobj     = ruleinputbox[2]
    $rulebaseobj = ruleinputbox[3]
    $ruleloc     = ruleinputbox[4]

  test_inputs

end


# TEST INPUTS
def test_inputs
   
  if( $rulename == "" )
    UI.messagebox "Rule Name is invalid.\nCould not create rule."
  else
    # print input values for testing purposes only
    # this section will get deleted in final code submission
    UI.messagebox "Rule name: #{$rulename}\n
                   Description: #{$ruledesc}\n
                   Object: #{$ruleobj}\n
                   Target Obj: #{},
                   Location: #{$ruleloc}"

    create_rule_file #send rule to get either created or discarded

  end

end



# ----- WRITE RULE TO FILE -----
# this code adds all variables created by input box to end of rules file

def create_rule_file

  # the user's filename input will become a filename.rb file 
  # if a rule exists by that same name, we do not create it.
  fname = "#{$rulename}.rb" # user input rulename will be rulename.rb
  oktocreate = 0            # create rule? 0 = no / 1 = yes

 
    if File.exist?(fname) # if a rule by the same name exists
      oktocreate = 0      # we do not make a new file
      UI.messagebox "ERROR: Rule name \"#{$rulename}\" already exists. Cannot create this rule."
    else                  # rule does not already exist
      oktocreate = 1      # Ok to create rule file
      File.open("#{fname}", 'w+')  # Create file for writing-to
      write_rule (fname)  # write the rule to file
    end

end


# WRITE RULE TO FILE with user input rule criteria
def write_rule( fname )

  time = Time.new # use this to create timestamp for rule file
  
  # open file with append - best to append rule as we parse input box
  accessfile = File.open("#{fname}", 'a')  

  # header descriptions
  accessfile.puts("\# Rule created in RuleBear.")
  accessfile.puts("\# Rule name: #{$rulename}, created on #{time.month}\/#{time.day}\/#{time.year}")
  accessfile.puts("\# #{$ruledesc}")  
  accessfile.puts("")
  
  # create the new rule
  accessfile.puts("def #{$rulename}")
  accessfile.puts("  UI.messagebox \"yay! my rule works!\" \# comment")
  accessfile.puts("end")
  accessfile.puts("")

  # add rule to menu
  


  # close the file 
  accessfile.close
end



  

# EDIT A RULE
# functionality not developed.


# DELETE A RULE
  # be conservative with this one


