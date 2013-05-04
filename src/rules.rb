# Primary Author: Maxine Major
# rules.rb
# This plugin defines 
#   rules affecting Lego class object placement
#   input boxes for rule creation
# 
# Created 4/16/2013
# Last updated 5/4/2013

require 'sketchup.rb'

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
    "top|side|corner"                    # Drop-down of placement locations
    ] 


  # DRAW INPUT BOX
  ruleinputbox = UI.inputbox prompts, 
                             defaults, 
                             attributes_list, 
                             "Create a Rule"   # title of input box

  #test input box creation
  if (ruleinputbox)                     # If box creation is successful
    initialize_boxvars( ruleinputbox )  # turn user inputs into variables

  else
    UI.messagebox "Error: Create a rule could not be launched."
   
  end

end


# Initialize variables with user input values from input box
def initialize_boxvars( ruleinputbox )

    $rulename    = ruleinputbox[0]
    $ruledesc    = ruleinputbox[1]
    $ruleobj     = ruleinputbox[2]
    $rulebaseobj = ruleinputbox[3]
    $ruleloc     = ruleinputbox[4]
    $fname       = "#{$rulename}.rb" # rule file will be rulename.rb 

  test_inputs

end


# TEST INPUTS: check for valid rule inputs.
def test_inputs

   # TEST RULE NAME
   
  if( $rulename == "" )
    UI.messagebox "Rule Name is invalid.\nCould not create rule."


  elsif ( File.exist?(File.join($rb_filepath, "#{$fname}")) )     
    UI.messagebox "ERROR: Rule name \"#{$rulename}\" already exists. 
                     Cannot create this rule."
    
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
    
    create_rule_file #send rule to get either created or discarded

  end



end


# ----- WRITE RULE TO FILE -----
# this code creates a new rule based on user input rulename
# and uses all input variables created by input box to create a rule

def create_rule_file

      
      # File.open("#{fname}", 'w+')  # Create file for writing-to
      File.open(File.join($rb_filepath, "#{$fname}"), 'w+')

      # verify location of this file
      filepath = File.expand_path(File.join($rb_filepath, "#{$fname}")) 
      
      write_rule  # write the rule to file

end


# WRITE RULE TO FILE with user input rule criteria
def write_rule

  # rule variables
  time = Time.new # use this to create timestamp for rule file
  menuname =  "#{$rulename}"+"_menu"
  menudesc = "#{$rulename}".capitalize
  defname  = "#{$rulename}"+"_def"

  # open file with append - best to append rule as we parse input box
  unless ( File.exist?(File.join($rb_filepath, "#{$fname}")) ) 
    UI.messagebox "Apparently the file #{$fname} doesn't exist."

  else # write to file

  accessfile = File.open(File.join($rb_filepath, "#{$fname}"), 'a')

  # header descriptions
  accessfile.puts("\# Rule created in RuleBear.")
  accessfile.puts("\# Rule name: #{$rulename}, created on #{time.month}\/#{time.day}\/#{time.year}")
  accessfile.puts("\# #{$ruledesc}")  
  accessfile.puts("")
  
  #require
  accessfile.puts("require \'sketchup.rb\'")
  accessfile.puts("require \'C\:\\Program Files \(x86\)\\Google\\Google SketchUp 8\\Plugins\\menu.rb\'") #use pc_plugins_dir
  accessfile.puts("")  

  # add rule to menu
  accessfile.puts("\# add #{$rulename} to menu") 
  accessfile.puts("UI.menu\(\"PlugIns\"\).add_item\(\"#{menudesc}\"\)\{") 
  accessfile.puts("  #{defname}")
  accessfile.puts("\}")  
  accessfile.puts("")  


  # create the new rule
  accessfile.puts("def #{defname}")
  accessfile.puts("  UI.messagebox \"yay! #{$rulename} works!\" \# comment")
  accessfile.puts("end")
  accessfile.puts("")

  # finished writing to our rules file
  # close the file 
  accessfile.close


  end

  # add to requires menu

  unless ( File.exist?( File.join( $rb_filepath, "rb_requires.rb" ) ) ) 
    UI.messagebox "can\'t find the requires file"

  else # write to file
    accessrequires = File.open(File.join($rb_filepath, "rb_requires.rb"), 'a')
    accessrequires.puts("require \'#{$rb_filepath}\\#{$fname}\'")



  end





  # close the file 
  accessrequires.close

  
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
    deletefile = "#{deletebox[0]}"+".rb"
    UI.messagebox "will be deleting #{deletefile}"
  else
    UI.messagebox "Error: Create a rule could not be launched."
   
  end

  #verify if rule deletion is necessary
  
  # delete file
  File.delete( File.join( $rb_filepath, "#{deletefile}" ) ) # yes, it's that easy


end
