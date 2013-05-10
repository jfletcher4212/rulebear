#Primary Author: Jason Fletcher
#Lego.rb
#This module provides the base Lego class, as well as the GUI #Sketchup calls that draw the lego, and a method for testing the #correctness of the non-GUI elements
#Created 3/31/13
#Last Updated 5/10/13
#require Node.rb
require 'sketchup.rb'
#Sketchup.send_action "showRubyPanel"


#These two variables contain the file paths of the components;
#We can't ensure that they are in fact the lego pieces and not
#  some other component renamed to 2x4.skp or 2x2.skp, so
#  if you want to see interesting (read: undefined) behavior
# I suppose you could try that...
$piece1 = Sketchup.find_support_file "2x4.skp", "Components/"
$piece2 = Sketchup.find_support_file "2x2.skp", "Components/"

#The default piece is set to be a 2x4
$selectedpiece = $piece1

#For information on changing the colors,
#see Sketchup's Color class.
#
#Note: it might be possible to save the color
#inside the ComponentDefinition file,
#but when I tried the color was not saved.
#  - Jason
$piece1color = "red"
$piece2color = "yellow"
$colorflag = true
#Again, default is 2x4, so color starts with piece1's set color
$piececolor = $piece1color
$model = Sketchup.active_model

#Keeping track of the last component is now
#used to build a 'tower' of legos...mostly just
#for fun at this point, but can be used to
#generate complex shapes at a later point.

$lastcomponent = nil

#A global tool observer object is used
#to determine whether selecting the move
#tool is allowed. There is an issue where
#one Sketchup tool used by RuleBear temporarily
#then tries to switch to the move tool, forcing
#the user to switch back to the RuleBear tool.
#In order to save user-frustration, we simply...
#prevent that.
$ruleToolsObserver = nil

#A global variable is given to store the relationship
#between the two pieces involved in the current placement,
#so that it can be used by the rules determination.
#As before, the relationship will be "top", "side", or "corner"

$relationship = nil


UI.menu("PlugIns").add_item("Activate RuleBear"){
  if( $piece1.nil? or $piece2.nil? )
    UI.messagebox "Sorry, I couldn't find one of the necessary pieces. Please make sure 2x2. and 2x4 are in Sketchup's \"Components/\" directory."
  else
    activate_BEAR
  end
}

#This creates the tools and observers necessary for rulebear to be used, then
#sets the active tool as the created PlacementTool, which handles most
#of the work.
def activate_BEAR
  Sketchup.active_model.add_observer(CompModelObserver.new)
  UI.messagebox "RuleBear activated. Please double-click to select initial location."
  placement_tool = PlacementTool.new

  Sketchup.active_model.select_tool placement_tool
end

#This acts as a simple switch.
#When it is activated, it will generate a
#new random color each time a Lego is placed.
#A possible alternative for this is to randomize
#$piece1color and $piece2color once, so all future
#pieces are the same random color.
def toggleColors

  if( $colorflag )
    UI.messagebox ("Using Random Colors")
    $colorflag = false
  else
    UI.messagebox ("Using Standard Colors")
    $piece1color = "red"
    $piece2color = "yellow"
    $colorflag = true
  end
end

#This prompts the user for a number, then
#creates a stack/tower of legos, starting from the
#last-placed brick.
def placeXPieces
        prompts  = ["How many pieces to place?"]
        defaults = ["100"]
        input = UI.inputbox prompts, defaults, "Place X pieces"

        #i is the specified number.
        #The to_i() method returns 0
        #if the input is not a number, so
        #there is no need to check the input.
        i = input[0].to_i
        j = 0
        
        while( j < i )
          addPieceRandomly
          j = j + 1
        end
end

#This function creates a new component instance
#and places it on the last placed component on
#a random location.
#Later versions can modify this to create a form
#of procedural generation via rules.
#Most of this code is modified from that
#used in normal placement, so look there for
#comments.
def addPieceRandomly
  if($lastcomponent == nil)
    UI.messagebox "Sorry, I can't find the brick that was placed last"
    break
  end
  test = $lastcomponent
  path = $selectedpiece
  model = Sketchup.active_model
  definitions = model.definitions
  definition = definitions.load path
  if( test.definition.name == "2x2" )
    max = 4
  else
    max = 8
  end
  if( definition.name == "2x2" )
    max2 = 4
  else
    max2 = 8
  end
  doo = test.transformation.clone
  ar = doo.to_a
  i = rand(max) + 1
  j = rand(max2) +  1
  entities = model.active_entities

  lego_offset = Offsets.new
  lego_offset.determine_offsets definition, test, i, j
  xloc = ar[12] + lego_offset.xoffset
  yloc = ar[13] + lego_offset.yoffset
  zloc = ar[14] + lego_offset.zoffset
  point = Geom::Point3d.new(xloc, yloc, zloc)
  transform = Geom::Transformation.new point
  instance = entities.add_instance definition, transform
  changeLegoColor( instance )
 
end



#The following "Observer" classes come from the Sketchup API,
#and reacting to various actions made by the user.

class RuleToolsObserver < Sketchup::ToolsObserver
  #When the sketchup method to place the component is called
  #and an object is placed, the method immediately tries to switch to
  #the move tool (id 21048), so this observer prevents that.
  #In fact, currently, selecting the move tool actually selects
  #the rulebear placement tool.
  #This may or may not be beneficial to later iterations, as
  #the ability to freely move objects is one of the largest obstacles
  #to a stud-to-socket connection system.
  #
  #To select the move tool, all a user needs to do is select
  #another tool first.
  def onActiveToolChanged( tools, tool_name, tool_id )
    puts tool_name
    if( tool_id == 21048 )
      placement_tool = PlacementTool.new
      Sketchup.active_model.select_tool placement_tool
    elsif( tool_name != "RubyTool" and tool_name != "ComponentTool" and tool_name != "CameraOrbitTool")
      Sketchup.active_model.tools.remove_observer($ruleToolsObserver)
      $ruleToolsObserver = nil
    

    end
  end
end


class LegoDefinitionObserver < Sketchup::DefinitionObserver
  def onComponentInstanceAdded( definition, instance )
#There is currently no purpose for this
    #but it can be used if something needs to happen
    #with a specific type of component
    #(ex, only 2x2 blocks)
  end
end


#This observer is currently used to add colors to new bricks being placed
#  and sets the lastcomponent variable to the new instance
class CompModelObserver < Sketchup::ModelObserver

  def onPlaceComponent( instance )
    changeLegoColor( instance )
  end

end

#This definition simply changes the color of an instance, either
#to a standard color, or to a newly-generated random color
def changeLegoColor( instance )

  if( instance.definition.name != "2x4" and instance.definition.name != "2x2" )
    break
  end

  if( $colorflag )
    instance.material = $piececolor
  else
    instance.material = Sketchup::Color.new(rand(256), rand(256), rand(256))
  end

  $lastcomponent = instance

end

#Offsets contains 3 variables, which are used to store
#the coordinate offsets when determining where to place
#a component instance in relation to another component
#instance.
#The determine_offsets method is the primary means of
#doing so.
class Offsets
  attr_accessor :xoffset, :yoffset, :zoffset
  def initialize
    @xoffset = 0
    @yoffset = 0
    @zoffset = 5
  end
  #placement_definition - the component definition that in instance will be
  #created from; ie, the definition of the piece to be placed
  #
  #placing_instance - the instance/lego piece that will be placed upon
  #
  #stud1 - the stud/node number of the piece being placed
  #
  #stud2 - the stud/node number of the piece being placed upon
  def determine_offsets placement_definition, placing_instance, stud1, stud2
    #To start with, we check the relationship between stud1 & stud2
    determine_relationship(placement_definition, placing_instance, stud1, stud2)
    #To simplify the placement algorithm, 2x2s can be
    #treated as 2x4s. To do this, if the desired node
    #is 3 or 4 on a 2x2, add 2 to make it 5 or 6, the
    #number of the same location on a 2x4 piece
#    determine_relationship( placement_definition, placing_instance, stud1, stud2 )
    i = stud1
    j = stud2
    if placement_definition.name == "2x2" and i > 2
      i = i + 2
    end
    if placing_instance.definition.name == "2x2" and j > 2
      j = j + 2
    end

    #xoffset is found first, and is a simple check
    #of whether both locations are on the same "side"
    if( i > 4 and j <= 4 )
      @xoffset = -8
    elsif( i <= 4 and j > 4 )
      @xoffset = 8
    end
    #For determining y offset, both locations are
    #modulo'd by 4 (wtih a 0 corresponding to the
    #4th location)
    i = i % 4
    if( i == 0 )
      i = 4
    end
    j = j % 4
    if( j == 0 )
      j = 4
    end
    
    #Then the difference of the two is calculated and
    #downsized so that one is 1. This way, similar shapes
    #both use the same placement algorithm. That is,
    #placing "location 2 on location 3" is the same as
    #        "location 1 on location 2" and
    #        "location 3 on location 4"
    #All three of these scenarios work exactly the same
    #with the following algorithm.
    if( i > j )
      i = i - j + 1
      j = 1
    else
      j = j - i + 1
      i = 1
    end
    @yoffset = ( i - j ) * (-8)
    #With both x and y offsets determined, we can return.
    #Future versions may require placing on the side or under
    #an existing piece. If so, determining the zoffset could
    #go here as well.
  end
end


#This method is used to determine the relationship of two pieces, and stores
#that relationship (top, side, or corner) in a global variable $relationship
#that can be accessed elsewhere.
#
#variables are identical to those found in the determine_offset method
#in the Offset class above.
def determine_relationship placement_definition, placing_instance, stud1, stud2
  #abs_value = absolute value of the difference between stud1 & stud2
  abs_value = stud1 - stud2
  abs_value = abs_value.abs
  if( placement_definition.name == placing_instance.definition.name )
    #if the pieces are the same, the logic is much simpler, for the most part
    if( placement_definition.name == "2x2" )
      max = 4
    else
      max = 8
    end
    if( stud1 == stud2 )
      $relationship = "top"
    elsif( abs_value == (max - 1)) #this covers stud #1 on stud #8, stud #1 on stud #4, & vice versa
      $relationship = "corner"
    #There might be a better/easier mathematical way to
    #determine this next part (stud 2 on stud 3-type corner),
    #but it hasn't been found at this point.
    #
    #Theoretically, perhaps a (max/2)+1 and (max/2)-1 check
    elsif(placement_definition.name == "2x2" and (stud1 == 2) and (stud2 == 3) )
      $relationship = "corner"
    elsif(placement_definition.name == "2x2" and (stud1 == 3) and (stud2 == 2) )
      $relationship = "corner"
    elsif(placement_definition.name == "2x4" and (stud1 == 4) and (stud2 == 5) )
      $relationship = "corner"
    elsif(placement_definition.name == "2x4" and (stud1 == 5) and (stud2 == 4) )
      $relationship = "corner"
    #This covers all possibilities for top and corner relationships
    #  on same size pieces, so all other same-size possiblities are "side"
    else
      $relationship = "side"
    end
  else
    #placing 2x2 on 2x4 or 2x4 on 2x2
    #For heterogenous placement, each corner stud
    #still has 1 possible "corner" partner, but
    #every stud now has 3 possible "top" stud partners.
    #
    i = stud1
    j = stud2
    #Only one of i or j will be changed
    #in the two following if-statements, depending
    #on whether the placing or placed brick is 2x2
    #(the other will be 2x4)
    if( placement_definition.name == "2x2" )
      if( stud1 == 2 )    
        i = 4
      elsif( stud1 == 3 )
        i = 5
      elsif( stud1 == 4 )
        i = 8
      else                
        i = 1
      end
    end
    if( placing_instance.definition.name == "2x2" )
      if( stud2 == 2 )    
        j = 4
      elsif( stud2 == 3 )
        j = 5
      elsif( stud2 == 4 )
        j = 8
      else                
        j = 1
      end
    end


    imod = i % 4
    jmod = j % 4
    
    abs_value = i - j
    abs_value = abs_value.abs
    if( abs_value == 7 )          #8-1 or 1-8 are the only relationships that
                                  #can be 7
      $relationship = "corner"
    elsif( i == 4 and j == 5 )    #Again, some arbitrary logic
      $relationship = "corner"    #to determine these corners
    elsif( i == 5 and j == 4 )
      $relationship = "corner"
    elsif( i/5 == j/5 )           #with Ruby, 1/5=0, 4/5=0, 5/5=1, 8/5=1 (integer division rounds down)
                                  #Meaning, if this is true, they are on the same side
      if(imod !=0 and jmod != 0)         
                                  #if neither is the far end, all nodes will be filled ("top")
        $relationship = "top"
      elsif( imod == 0 and placement_definition.name == "2x2" and jmod != 1)
        $relationship = "top"
      elsif( jmod == 0 and placing_instance.definition.name == "2x2" and imod != 1)
        $relationship = "top"
      else
        $relationship = "side"    #otherwise, only some get filled, ex 1 on 4
      end
    else
      $relationship = "side"      #only half get filled, ex. 1 on 5, 2 on 5
    end                           #This covers all possible relationships.
  end

end

class PlacementTool
  def activate
    if( $ruleToolsObserver.nil? )
      $ruleToolsObserver = RuleToolsObserver.new
      Sketchup.active_model.tools.add_observer($ruleToolsObserver)
    end  
  end
  #Double-clicking on empty space
  #sets an initial location for the block.
  #
  #Double-clicking on an object (one singular object!)
  #will bring up an input box that allows the user to
  #select the stud to place on and the "rule" or location
  #
  #It was attempted to place via a stud-to-socket relationship,
  #but in our current design this is an even more complex process
  #than what we currently have.
  #
  #If the stud-to-socket relationship can be established, then the
  #"top, side, corner" relationship can be determined based on that,
  #and rules can determine whether it is allowed.
  #
  #Furthermore, with a stud-to-socket relationship, orientation could
  #be re-introduced, after being removed with the introduction of
  #Component usage.
  #
  #onLButtonDoubleClick is called by sketchup when this is the selected tool
  #flags - ??? Not used by this function
  #x - the x coordinate of the screen (as opposed to sketchup's internal view coordinates)
  #y - same as x
  #view - the view being double-clicked on? Not used by this function
  def onLButtonDoubleClick ( flags, x, y, view )
    ip1 = view.inputpoint x, y
    point1 = ip1.position
    #The next 2 lines access the objects below the current mouse location
    ip2 = view.pick_helper
    count = ip2.do_pick x, y
    #If there is more than one object below the current location,
    #there is no easy way of knowing which is which in the list.
    #Thus, to ensure there is no undefined behavior resulting from
    #picking one at random, the placement will only occur if only one entity is in
    #the list. If there is more than one entity, the user must try again.
    if( count > 1 )
      UI.messagebox "Error: There is more than one entity under the double-clicked location.\nPlease try a different spot."
    elsif( count == 0 )
      placeNewLego2 $selectedpiece
    else
      #At this point, the object is assumed to be a single component instance
      #testing
      test = ip2.element_at(0)
      puts test.typename
     
     
      if( test.definition.name == "2x2" or test.definition.name == "2x4" )
      
        #  Jason is primary author for below content
        #  Maxine is responsible for poor formatting and nested if statements. 
      if( test.definition.name == "#{$active_target}") 
      if( $selectedpiece == $active_piece  )
      
       
      #prompt for position
      #RULE STUFF SHALL GO HERE
      #...maybe
      


        #The next two variables create a "transformation"
        # object (for more information, see Sketchup's
        # documentation), then gets an array with all
        # the transformation's data. Some elements of this
        # array are used shortly.
        doo = test.transformation.clone
        ar = doo.to_a
        #Creates an input box for selection the exact location
        #Then does something different for each combination
        prompts  = ["Select placing Node #", "select placement node #"]
        defaults = ["1", "1"]
        input = UI.inputbox prompts, defaults, "Select placement location"

        if( test.definition.name == "2x2")
          maxbounds = 8
        else
          maxbounds = 8
        end

        #i and location are set according
        # to the input from the user.
        #They will be used shortly
        i = input[0].to_i
        location = input[1].to_i

        #This check is most likely antiquated;
        #The bounds are checked when the offsets
        # are being determined.
        if( i < 1 or i > maxbounds )
          UI.messagebox "Error, input exceeds bounds or is not a number"
          break
        end

        #Next, we load the definition of the piece to be placed
        path = $selectedpiece
        model = Sketchup.active_model
        definitions = model.definitions
        entities = model.active_entities
        definition = definitions.load path

        #An offset object is created, which will be used in placement.
        #For additional information, see the Offsets class.
        lego_offset = Offsets.new
        lego_offset.determine_offsets definition, test, i, location

        if( $relationship != $active_loc ) 
          UI.messagebox "Incorrect location"
          break
        end

        #With the offsets now determined, we can create a point
        #And put the new instance at that location.
        #The "ar" array from earlier is used to get current offset
        #Elements 12-14 are the coordinates
        #
        xloc = ar[12] + lego_offset.xoffset
        yloc = ar[13] + lego_offset.yoffset
        zloc = ar[14] + lego_offset.zoffset
        #Coordinates determined, a point can be created,
        #then a transformation from that point,
        #then an instance with that point.
        point = Geom::Point3d.new(xloc, yloc, zloc)
        transform = Geom::Transformation.new point
        instance = entities.add_instance definition, transform
        #note that this method of placement does not trigger the
        #model observer (see the "observer" section above)
        changeLegoColor(instance)
        puts $relationship
      else
        UI.messagebox "Invalid object placement"
      end
    end
    end
    end
  end
end


  

#This method is used when placing
#a component on empty space;
#The observer keeps the place_component
#method from changing tools to the move_tool
#
#piece is the file path of the component definition to be added
def placeNewLego2( piece )
 
  model = Sketchup.active_model
  entities = model.entities
  path1 = model.definitions.load piece
  path1.add_observer(LegoDefinitionObserver.new)
  model.place_component path1

end




#The rest of these are merely for testing/debugging,
#and are commented out in the final version
=begin
UI.menu("PlugIns").add_item("Print Selected Object IDs"){
  printstuff
}

def printstuff
  Sketchup.active_model.add_observer(CompModelObserver.new)
  Sketchup.active_model.tools.add_observer(RuleToolsObserver.new)
  Sketchup.active_model.selection.each{ |x| puts x.object_id }
end

UI.menu("PlugIns").add_item("test_add_instance"){
  test_add_instance
}

def test_add_instance
  point = Geom::Point3d.new 10, 10, 10
  transform = Geom::Transformation.new point
  model = Sketchup.active_model
  path = $piece1
  definitions = model.definitions
  entities = model.active_entities
  definition = definitions.load path
  instance = entities.add_instance definition, transform
  if( instance )
    puts "Good instance"
  else
    puts "Bad instance"
  end
end
=end




