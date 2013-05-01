#Primary Author: Jason Fletcher
#  Modified by Maxine 4/14/13 - commented out menu.add_items. 
#  Added to menu.rb
#Lego.rb
#This module provides the base Lego class, as well as the GUI #Sketchup calls that draw the lego, and a method for testing the #correctness of the non-GUI elements
#Created 3/31/13
#Last Updated 4/16/13
#require Node.rb
require 'sketchup.rb'
#Sketchup.send_action "showRubyPanel"

# new stuff added 4/9
# Objects can now be placed anywhere with a double-click, and can be of size:
# 2x4
# 
# 2x2
#
# new stuff added 4/14
# added start of "node" linked list for searching/matching as part of
# placement

$nodesL = 2
$nodesW = 4
$piece1 = Sketchup.find_support_file "2x4.skp", "Components/"
$piece2 = Sketchup.find_support_file "2x2.skp", "Components/"
$selectedpiece = $piece1
$piece1color = "red"
$piece2color = "yellow"
$piececolor = $piece1color
$model = Sketchup.active_model
$lastcomponent = nil

class CompModelObserver < Sketchup::ModelObserver
  def onPlaceComponent( instance )

    placement_tool = PlacementTool.new
    Sketchup.active_model.select_tool placement_tool
#    puts instance.definition.name
    instance.material = $piececolor
    $lastcomponent = instance

  end

end



class RuleToolsObserver < Sketchup::ToolsObserver
  #When the sketchup method to place the component is called
  #and an object is placed, the method immediately tries to switch to
  #the move tool (id 21048), so this observer prevents that
  def onActiveToolChanged( tools, tool_name, tool_id )
    if( tool_id == 21048 ) 
      placement_tool = PlacementTool.new
      Sketchup.active_model.select_tool placement_tool
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
  def determine_offsets placement_definition, placing_instance, i, location
     if( location != "side" and location != "top" and location != "corner" )
       UI.messagebox "Error, incorrect location."
       break
     elsif( placing_instance.definition.name == "2x2" and i > 4 )
       UI.messagebox "Error, 2x2 piece does not have locations above 4."
       break
     elsif( i < 1 or i > 8 ) 
       UI.messagebox "Error, cannot place on the stud specified."
       break
     end


     definition = placement_definition
     test = placing_instance
     puts test.definition.name
     puts definition.name

     # At this point, we know there is a stud between 1 and 8, and a valid location, and can thus continue


     # Here is the big, simple yet tedious process of determining offset
     # as a way of "connecting" the pieces.

     # Each case (2x2 on 2x2, 2x2 on 2x4, 2x4 on 2x2, 2x4 on 2x2) has
     # a different way to determine offset, unless a new method of
     # determining it can be found. A mathematical algorithm would
     # be ideal, but to this point we have not been able to create
     # one.

     if( definition.name == "2x2" )         #placing a 2x2 piece

       if( test.definition.name == "2x2" )  #placing on 2x2
         
         if( i == 1 )                       #for each node, find where
           if( location == "top" )          #the user wanted it placed
             @xoffset = 0                   #and create offset based on that
             @yoffset = 0
           elsif(location == "side")  
             @xoffset = -8.2
             @yoffset = 0
           elsif(location == "corner")
             @xoffset = -8.2
             @yoffset = -8.2
           end
         
         elsif( i == 2)
           if( location == "top" )
             @xoffset = 0
             @yoffset = 0
           elsif(location == "side")  
             @xoffset = 0
             @yoffset = 7.8
           elsif(location == "corner")
             @xoffset = -7.8
             @yoffset = 7.8
           end
         
         elsif( i == 3)
           if( location == "top" )
             @xoffset = 0
             @yoffset = 0
           elsif(location == "side")  
             @xoffset = 7.8
             @yoffset = 0
           elsif(location == "corner")
             @xoffset = 7.8
             @yoffset = 7.8
           end
         
         elsif( i == 4)
           if( location == "top" )
             @xoffset = 0
             @yoffset = 0
           elsif(location == "side")  
             @xoffset = 0
             @yoffset = -8.2
           elsif(location == "corner")
             @xoffset = 7.8
             @yoffset = -8.2
           end
         end

       else 
         #Placing on 2x4
         if( i == 1 )
           if( location == "top" )
           elsif(location == "side")  
             @xoffset = -8.2
             @yoffset = 0
          elsif(location == "corner")
               @xoffset = -8.2
               @yoffset = -8
            end        
          elsif( i == 2 )
            if( location == "top" )
              @yoffset = 7.8
            elsif(location == "side")  
              @xoffset = -8.2
              @yoffset = 8
            elsif(location == "corner")
              UI.messagebox "Error, this stud isn't a corner"
              break
            end        
          elsif( i == 3 )
            if( location == "top" )
              @yoffset = 15.8
            elsif(location == "side")  
              @xoffset = -8.2
              @yoffset = 15.8
            elsif(location == "corner")
              UI.messagebox "Error, this stud isn't a corner"
              break
            end        
          elsif( i == 4 )
            if( location == "top" )
              @yoffset = 15.8
            elsif(location == "side")  
               @xoffset = 0
               @yoffset = 23.8
            elsif(location == "corner")
               @xoffset = -8.2
               @yoffset = 23.8
            end        
          elsif( i == 5 )
            if( location == "top" )#do nothing, offsets already 0
            elsif(location == "side")  
               @xoffset = 0
               @yoffset = -8.2
            elsif(location == "corner")
               @xoffset = 7.8
               @yoffset = -8
            end        
          elsif( i == 6 )
            if( location == "top" )
              @yoffset = 7.8
            elsif(location == "side")  
              @xoffset = 7.8
              @yoffset = 0
            elsif(location == "corner")
              UI.messagebox "Error, this stud isn't a corner"
              break
            end        
          elsif( i == 7 )
            if( location == "top" )
              @yoffset = 15.8
            elsif(location == "side")  
              @xoffset = 7.8
              @yoffset = 8
            elsif(location == "corner")
              UI.messagebox "Error, this stud isn't a corner"
              break
            end        
          elsif( i == 8 )
            if( location == "top" )
              @yoffset = 15.8
            elsif(location == "side")  
              @xoffset = 7.8
              @yoffset = 16
            elsif(location == "corner")
              @xoffset = 7.8
              @yoffset = 23.8
            end        #end top,side,corner
          end          #end i ==
         end            #end test.definition.name == 2x2

       
      else #placing a 2x4
       
        if( test.definition.name == "2x2" )
        #placing on 2x2
       
          if( location == "top" )         # For 2x4 interactions, a different
            if( i == 1 )                  # method is used, in order to gauge
            elsif( i == 2 )               # which one is less code-intensive.
              @yoffset = -7.8       
            elsif( i == 3 or i == 4 )     # Ultimately, however, we hope to replace
              @yoffset = -15.8            # Both types of interaction with a single,
            end                           # clean method of placement.
          elsif( location == "corner" )
            if( i == 1 )
              @xoffset = -8
              @yoffset = -24.2
            elsif( i == 2 )
              @xoffset = -8
              @yoffset = 7.8
            elsif( i == 3 )
              @xoffset = 8
              @yoffset = -24.2
            elsif( i == 4 )
              @xoffset = 8
              @yoffset = 7.8
            end
          elsif( location == "side" )
            if( i == 1 )
              @yoffset = -24.2
            elsif( i == 2 )
              @xoffset = -8
              @yoffset = -8.2
            elsif( i == 3 )
              @yoffset = 7.8
            elsif( i == 4 )
              @xoffset = 8
              @yoffset = -8.2
            end
          else
          end
        else

          #placing on 2x4
          if(location == "top")        #offsets are already 0 and thus correct
          elsif(location == "corner")
            if(i != 1 and i != 4 and i != 5 and i != 8)
              UI.messagebox "Error, this stud isn't a corner"
              break
            elsif( i == 1 )
              @xoffset = -8
              @yoffset = -24.2
            elsif( i == 4 )
              @xoffset = -8
              @yoffset = 23.8
            elsif( i == 5 )
              @xoffset = 8
              @yoffset = -24.2
            elsif( i == 8 )
              @xoffset = 8
              @yoffset = 23.8
            end
        elsif( location == "side" ) 
        #Note: there are more potential "side" locations than can be represented in this way,
          #another reason to change this to something better
          if( i == 1 )
            @xoffset = -8
            @yoffset = -16.2
          elsif( i == 2 )
            @xoffset = -8
            @yoffset = -8.2
          elsif( i == 3 )
            @xoffset = -8
            @yoffset = 7.8
          elsif( i == 4 )
            @xoffset = -8
            @yoffset = 15.8
          elsif( i == 5 )
            @xoffset = 0
            @yoffset = -24.2
          elsif( i == 6 )
            @xoffset = 8
            @yoffset = -8.2
          elsif( i == 7 )
            @xoffset = 8
            @yoffset = 7.8
          elsif( i == 8 )
            @xoffset = 0
            @yoffset = 23.8
          end
        end
      end
    end
     
  end
end


class PlacementTool
  def activate
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
  #
  #prompt for position
  #do stuff/checks :D
  #RULE STUFF SHALL GO HERE :D
  #

        doo = test.transformation.clone
        ar = doo.to_a
  #Creates an input box for selection the exact location
  #Then does something different for each combination D:!
        prompts = ["Select Node #", "select location (top, corner, side)"]
        defaults = ["1", "top"]
        input = UI.inputbox prompts, defaults, "Select placement location"
        if( test.definition.name == "2x2")
          maxbounds = 4
        else
          maxbounds = 8
        end
        i = input[0].to_i
        location = input[1]
        if( i < 1 or i > maxbounds )
          UI.messagebox "Error, input exceeds bounds or is not a number"
          break
        end
        xoffset=0
        yoffset=0

        path = $selectedpiece
        model = Sketchup.active_model
        definitions = model.definitions
        entities = model.active_entities
        definition = definitions.load path
        lego_offset = Offsets.new
        lego_offset.determine_offsets definition, test, i, location
        #With the offsets now determined, we can create a point
        #And put the new instance at that location.
        puts ("x: " + lego_offset.xoffset.to_s)
        puts ("y: " + lego_offset.yoffset.to_s)
        puts ("z: " + lego_offset.zoffset.to_s)

        xloc = ar[12] + lego_offset.xoffset
        yloc = ar[13] + lego_offset.yoffset
        zloc = ar[14] + lego_offset.zoffset
        point = Geom::Point3d.new(xloc, yloc, zloc)
        transform = Geom::Transformation.new point
        instance = entities.add_instance definition, transform
        instance.material = $piececolor
        $lastcomponent = instance
      else
        UI.messagebox "You double-clicked on a component other than a lego :("
      end
    end
  end
end

#In the current build, there's no need for this and it does nothing,
#But I'll keep it in just in case another tool is needed at a later time.
class RuleTool
  def activate
  end
  def onLButtonDoubleClick( flags, x, y, view)
  end
end
   

UI.menu("PlugIns").add_item("Activate bear"){
  if( $piece1.nil? or $piece2.nil? )
    UI.messagebox "Sorry, I couldn't find one of the necessary pieces. Please make sure 2x2. and 2x4 are in Sketchup's Components/ directory."
  else
    activate_BEAR

  end
}

def placeNewLego2( piece )
 
  model = Sketchup.active_model
  entities = model.entities
  path1 = model.definitions.load piece
  path1.add_observer(LegoDefinitionObserver.new)
  model.place_component path1

end

def activate_BEAR
  Sketchup.active_model.add_observer(CompModelObserver.new)
  Sketchup.active_model.tools.add_observer(RuleToolsObserver.new)
  UI.messagebox "RuleBear activated. Please double-click to select initial location."
  placement_tool = PlacementTool.new
  Sketchup.active_model.select_tool placement_tool
end




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
