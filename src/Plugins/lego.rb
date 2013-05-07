#Primary Author: Jason Fletcher
#Lego.rb
#This module provides the base Lego class, as well as the GUI #Sketchup calls that draw the lego, and a method for testing the #correctness of the non-GUI elements
#Created 3/31/13
#Last Updated 5/1/13
#require Node.rb
require 'sketchup.rb'
#Sketchup.send_action "showRubyPanel"


#nodesL and nodesW are not used in the final
#version, as legos are created via ComponentDefinitions
#and ComponentInstances (see Sketchup documentation).
#If new lego shapes (4x2, 10x10, etc.) are asked for in later
#version, used these two variables with "placeNewLego"
#from the appendix.
$nodesL = 2
$nodesW = 4

#These two contain the file paths of the components;
#We can't ensure that they are in fact the lego pieces and not
#some other component renamed to 2x4.skp or 2x2.skp, so
#if you want to see interesting (read: undefined) behavior
#I suppose you could try that...
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

#Keeping track of the last component is not
#necessary in the current build, but may
#have uses in later iterations
$lastcomponent = nil
$numRTObservers = 0
$ruleToolsObserver = nil

def toggleColors

  if( $colorflag )
    UI.messagebox ("Using random colors")
    $colorflag = false
  else
    UI.messagebox ("Using red for 2x4 and yellow for 2x2")
    $piece1color = "red"
    $piece2color = "yellow"
    $colorflag = true
  end
end
def placeXPieces
        prompts  = ["How many pieces to place?"]
        defaults = ["100"]
        input = UI.inputbox prompts, defaults, "Place X pieces"

        #i and location are set according 
        # to the input from the user.
        #They will be used shortly
        i = input[0].to_i
        j = 0
        while( j < i )
          addPieceRandomly
          j = j + 1
        end
end


def addPieceRandomly
  if($lastcomponent == nil)
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
  location = rand(max2) +  1
  entities = model.active_entities

  lego_offset = Offsets.new
  lego_offset.determine_offsets definition, test, i, location
  xloc = ar[12] + lego_offset.xoffset
  yloc = ar[13] + lego_offset.yoffset
  zloc = ar[14] + lego_offset.zoffset
  point = Geom::Point3d.new(xloc, yloc, zloc) 
  transform = Geom::Transformation.new point
  instance = entities.add_instance definition, transform
  if( $colorflag )
    instance.material = $piececolor
  else
    instance.material = Sketchup::Color.new(rand(256), rand(256), rand(256))
  end
  $lastcomponent = instance
 
end

class CompModelObserver < Sketchup::ModelObserver
  def onPlaceComponent( instance )

#    placement_tool = PlacementTool.new
#    Sketchup.active_model.select_tool placement_tool
#    puts instance.definition.name

    if( $colorflag )
      instance.material = $piececolor
    else
      instance.material = Sketchup::Color.new(rand(256), rand(256), rand(256))
    end

    $lastcomponent = instance

  end

end



class RuleToolsObserver < Sketchup::ToolsObserver
  #When the sketchup method to place the component is called
  #and an object is placed, the method immediately tries to switch to
  #the move tool (id 21048), so this observer prevents that.
  #Unfortunately, we haven't found a way of undoing this yet.
  #Due to this, once Rulebear is activated, it is impossible to
  #move objects in the normal way.
  #In fact, currently, selecting the move tool actually selects
  #the rulebear placement tool.
  #This may or may not be beneficial to later iterations, as
  #the ability to freely move objects is one of the largest obstacles
  #to a stud-to-socket connection system.
  #
  #If it is, in fact, decided that this should be fixed, rough pseudocode has
  #been added as a basic idea of how to do so.
  def onActiveToolChanged( tools, tool_name, tool_id )
    puts tool_name
    if( tool_id == 21048 )
      placement_tool = PlacementTool.new
      Sketchup.active_model.select_tool placement_tool
    elsif( tool_name != "RubyTool" and tool_name != "ComponentTool" and tool_name != "CameraOrbitTool")
      Sketchup.active_model.tools.remove_observer($ruleToolsObserver)
      $numRTObservers = 0
      $ruleToolsObserver = nil
    

######PSEUDOCODE BEGIN########
      #
      #else
      ### remove the RuleToolsObserver from the tools object
      #  Sketchup.active_model.tools.remove observer $observer
      ### Note that $observer does not exist at the moment;
      ### It will have to be created and then set when the observer
      ### is first made.
      #
      #
      ### There may be an issue if the user changes from the
      ### rulebear tool to the rulebear tool.
      #
      ### That is,
      #   >  User activates rulebear the first time
      #   >  rulebear creates an observer, changes $observer to
      #         point to that observer
      #   >  User activates rulebear a second time
      #   >  rulebear creates an observer; changes $observer to
      #         that observer
      #   >  onActiveToolChanged activates, deactivating the second observer
      #   >  The original observer from when rulebear was first activated
      #   >     is still intact, and cannot be deactivated.
      #   This is just hypothetical, as I'm not sure about the specific
      #   chain of events when changing tools.
      #
#######PSEUDOCODE END######

    end
  end
end

begin
class LegoDefinitionObserver < Sketchup::DefinitionObserver
  def onComponentInstanceAdded( definition, instance )
#There is currently no purpose for this
  end
end
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
  #i - the stud/node number that will be placed on
  #
  #location - the type of connection that will be made (ie, "side, top, corner"
  def determine_offsets placement_definition, placing_instance, i, j
    #To simplify the placement algorithm, 2x2s can be
    #treated as 2x4s. To do this, if the desired node
    #is 3 or 4 on a 2x2, add 2 to make it 5 or 6, the
    #number of the same location on a 2x4 piece
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
    #an existing piece...If so, determining the zoffset could
    #go here as well.
  end
end


class PlacementTool
  def activate
    if( $numRTObservers == 0 )
      $ruleToolsObserver = RuleToolsObserver.new
      Sketchup.active_model.tools.add_observer($ruleToolsObserver)
      $numRTObservers = 1
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
     
     
      #if( test.definition.name == "2x2" or test.definition.name == "2x4" )
      
      if( test.definition.name == "#{$active_target}") 
      #     $selected_piece == $active_piece  )
       
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

        #This check is antiquated;
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
        if( $colorflag )
          instance.material = $piececolor
        else
          instance.material = Sketchup::Color.new(rand(256), rand(256), rand(256))
        end
        $lastcomponent = instance
        #"lastcomponent" is not used in the current version,
        #but may have use in later iterations.
      else
        UI.messagebox "Invalid object placement"
      end
    end
  end
end

#In the current build, there's no need for this and it does nothing,
#But I'll keep it in just in case another tool is needed at a later time.
#class RuleTool
#  def activate
#  end
#  def onLButtonDoubleClick( flags, x, y, view)
#  end
#end
   

UI.menu("PlugIns").add_item("Activate bear"){
  if( $piece1.nil? or $piece2.nil? )
    UI.messagebox "Sorry, I couldn't find one of the necessary pieces. Please make sure 2x2. and 2x4 are in Sketchup's \"Components/\" directory."
  else
    activate_BEAR

  end
}

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

#This creates the tools and observers necessary for rulebear to be used, then
#sets the active tool as the create PlacementTool
def activate_BEAR
  Sketchup.active_model.add_observer(CompModelObserver.new)
  UI.messagebox "RuleBear activated. Please double-click to select initial location."
  placement_tool = PlacementTool.new

  Sketchup.active_model.select_tool placement_tool
end



#The rest of these are merely for testing/debugging,
#and are commented out in the final
#version
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
    puts ":D"
  else
    puts "D:"
  end
end
=end


