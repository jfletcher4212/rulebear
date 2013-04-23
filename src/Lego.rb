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
# 4x2
# 2x2
#
# new stuff added 4/14
# added start of "node" linked list for searching/matching as part of
# placement

$nodesL = 2
$nodesW = 4
$piece1 = Sketchup.find_support_file "2x4.skp", "Components/"
$piece2 = Sketchup.find_support_file "2x2.skp", "Components/"
$piece1color = "red"
$piece2color = "yellow"
$piececolor = $piece1color
$model = Sketchup.active_model
$lastcomponent = nil

class CompModelObserver < Sketchup::ModelObserver
  def onPlaceComponent( instance )
    if( instance.definition.name == "2x2" )
      puts "I dunno if I should allow this..."
    end
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
#    instance.material=$piece2color
#    puts "did I do it?"
  end
end
end



class PlacementTool
  #On activation, display a box with initial instructions
  def activate
  end
  #Double-clicking sets an initial location for the block,
  #then will (in the future) activate another tool for rule based doodadery
  def onLButtonDoubleClick ( flags, x, y, view )
    ip1 = view.inputpoint x, y
    point1 = ip1.position

    ip2 = view.pick_helper
    count = ip2.do_pick x, y
    if( count > 1 )
      UI.messagebox "I'm sorry, that location is invalid right now. Please try another point"
    elsif( count == 0 )
      if( $nodesL == 4 or $nodesW == 4 )
        $piececolor = $piece1color
        placeNewLego2 $piece1
      else
        $piececolor = $piece2color
        placeNewLego2 $piece2
      end
    #From here, hand control to the RuleTool
#    rule_tool = RuleTool.new
#    Sketchup.active_model.select_tool rule_tool
    else
      #At this point, the object is assumed to be a single component instance
      test = ip2.element_at(0)
      
#     this does not work :(
#      if( test.typename == "ComponentInstance" )
 	      puts test.typename
#      end
      if( test.definition.name == "2x2" or test.definition.name == "2x4" )
        puts "Welp, this worked"
	#
	#prompt for position
	#do stuff/checks :D
	#RULE STUFF SHALL GO HERE :D
	#
	t2 = test.transformation.clone
#	t2.move
	puts t2	
      else
	UI.messagebox "You double-clicked on a component other than a lego :("
      end
    end
  end
end

class RuleTool
  def activate
    UI.messagebox "I really don't know what I'm doing"
  end
  def onLButtonDoubleClick( flags, x, y, view)
    #Check LL of nodes and place according to nodes
  end
end
   

UI.menu("PlugIns").add_item("Activate bear"){
  if( $piece1.nil? or $piece2.nil? )
    UI.messagebox "Sorry, I couldn't find one of the necessary pieces. Please make sure 2x2. and 2x4 are in Sketchup's Components/ directory."
  else
    activate_BEAR
  end
}

lalamenu = UI.menu "Plugins"


def placeNewLego2( piece )
 
  model = Sketchup.active_model
  entities = model.entities
  path1 = model.definitions.load piece
  puts path1
  puts path1.name
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




UI.menu("PlugIns").add_item("Printstuff"){
  printstuff
}

def printstuff
  Sketchup.active_model.add_observer(CompModelObserver.new)
  Sketchup.active_model.tools.add_observer(RuleToolsObserver.new)
  Sketchup.active_model.selection.each{ |x| puts x.object_id }
end

