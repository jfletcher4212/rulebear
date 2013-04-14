#Primary Author: Jason Fletcher
#  Modified by Maxine 4/14/13 - commented out menu.add_items. 
#  Added to menu.rb
#Lego.rb
#This module provides the base Lego class, as well as the GUI #Sketchup calls that draw the lego, and a method for testing the #correctness of the non-GUI elements
#Created 3/31/13
#Last Updated 4/14/13
#require Node.rb
require 'sketchup.rb'
#Sketchup.send_action "showRubyPanel"

#new stuff added 4/9
#
#
$nodesL = 2
$nodesW = 4
class PlacementTool
  #On activation, display a box with initial instructions
  def activate
    UI.messagebox "Rulebear activated. Please double-click to select initial location."
    #if 2x2 and 2x4 allowed for starting piece, pop up box for choice
    #else just default to one, and notify user which piece is initial
  end
  #Double-clicking sets an initial location for the block,
  #then will (in the future) activate another tool for rule based doodadery
  def onLButtonDoubleClick ( flags, x, y, view )
    ip1 = view.inputpoint x, y
    point = ip1.position
    placeNewLego( point.x, point.y, point.z, $nodesL, $nodesW )

    #From here, hand control to the RuleTool
#    rule_tool = RuleTool.new
#    Sketchup.active_model.select_tool rule_tool

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
   

#UI.menu("PlugIns").add_item("Draw 2x4"){
#  draw_2x4
#}
#UI.menu("PlugIns").add_item("Draw 2x2"){
#  draw_2x2
#}
UI.menu("PlugIns").add_item("Activate bear"){
  activate_BEAR
}
#UI.menu("PlugIns").add_item("Flip orientation"){
#  $nodesL,$nodesW = $nodesW,$nodesL
#  str = "Now placing " + $nodesL.to_s + "x" + $nodesW.to_s
#  UI.messagebox(str)
#}
#UI.menu("PlugIns").add_item("Place 2x4"){
#  $nodesL = 2
#  $nodesW = 4
#}
#UI.menu("PlugIns").add_item("Place 2x2"){
#  $nodesL = 2
#  $nodesW = 2
#}


class Lego
  attr_reader :pt1, :pt2, :pt3, :pt4
  attr_reader :length, :width, :height, :nodeRadius
  attr_reader :nodes1, :nodes2, :nodesHeight
  attr_accessor :centerL, :centerW #, :nodes

  #This method sets the nodes, and readjusts the length/width to match
  def setNodes( nodes1, nodes2 )
    @nodes1 = nodes1
    @nodes2 = nodes2
    @length = (@nodes1 * 8) - 0.2
    @width  = (@nodes2 * 8) - 0.2
  end

  #This method reinitializes the cube points based on the length and width.
  #It also sets the nodesCirc and nodesHeight values, based on x & y
  def setPos( x, y, z )
   
    @pt1[0] = x
    @pt1[1] = y
    @pt1[2] = z

    @pt2[0] = x + @length
    @pt2[1] = y
    @pt2[2] = z

    @pt3[0] = x + @length
    @pt3[1] = y + @width
    @pt3[2] = z

    @pt4[0] = x
    @pt4[1] = y + @width
    @pt4[2] = z
   
    @centerL = @nodesCirc + x
    @centerW = @nodesCirc + y
  end

  #This method sets the object's default values (called with new)
  def initialize(x, y, z, nodes1, nodes2)
    @pt1 = Array.new(3)
    @pt2 = Array.new(3)
    @pt3 = Array.new(3)
    @pt4 = Array.new(3)
#Add this in when I figure out how to access an array inside a class
#    nodes = Array.new(nodes1) {Array.new(nodes2)}
    @height = 5.0

    @nodeRadius = 2.5
    @nodesCirc = 3.9
    @nodesHeight = 1.7
   
    setNodes( nodes1, nodes2 )
    setPos( x, y, z )

  end
 

end

#A wrapper function for creating a new lego.
def makeLego( x, y, z, n1, n2 )

  new_lego = Lego.new( x, y, z, n1, n2 )

  return new_lego

end

#This function handles all the graphical elements of lego creation.
def placeNewLego( x, y, z, n1, n2 )
 
  model = Sketchup.active_model
  entities = model.entities

  new_lego = makeLego( x, y, z, n1, n2 )
 
  normal_vector = Geom::Vector3d.new(0,0,1)
  nodes = Array.new(n1) {Array.new(n2)}

  i = j = 0
  temp = new_lego.centerW
  zz = new_lego.pt1[2] + new_lego.height
  #This while loop creates all the nodes (cylinders on top)
  #ATTENTION: Something to be fixed:
  #Drawing a circle on an existing cube (ex. placing a lego under another lego)
  #and trying to make it a face causes an error.
  #We need to check if it's already a face, and if it is, don't create the node.
  while( i < n1 )
    while( j < n2 )
      center_point = Geom::Point3d.new( new_lego.centerL, new_lego.centerW, zz)
#      puts new_lego.nodes.type
#change this part later
      nodes[i][j] = entities.add_circle center_point, normal_vector, new_lego.nodeRadius
      new_face = entities.add_face nodes[i][j]
      edge = nodes[i][j][0]
      arccurve = edge.curve
      status = new_face.pushpull new_lego.nodesHeight, true
      new_lego.centerW = new_lego.centerW + 8
      j = j + 1
    end
    new_lego.centerL = new_lego.centerL + 8
    j = 0
    new_lego.centerW = temp
    i = i + 1
  end
 
  #This makes the body of the lego (cube)
  #
  #Since faces are pushed/pulled towards the z axis, we must check whether the zpos is
  #positive or negative, and compensate.
  if( z > 0 )
    height = new_lego.height
  end
  if( z <= 0 )
    height = -1 * new_lego.height
  end

  new_face1 = entities.add_face( new_lego.pt1, new_lego.pt2, new_lego.pt3, new_lego.pt4 )
  status = new_face1.pushpull height, true
end

def activate_BEAR
  placement_tool = PlacementTool.new
  Sketchup.active_model.select_tool placement_tool
end

def draw_2x2

 model = Sketchup.active_model
 selection = model.selection
 entities = model.active_entities
 status = selection.single_object?
 UI.messagebox status
#  placeNewLego( 0, 0, 5, 2, 2 )
end

def draw_2x4
  model = Sketchup.active_model
  selection = model.selection
  if( selection.count > 1 )
    puts "Please only select one location"
  elsif( selection.count < 1 )
    puts "Attempting to place on empty spot"
    placeNewLego( 0, 0, 0, 2, 4 )
  else
    puts selection[0].type
    placeNewLego( 0, 0, 0, 2, 4 )
  end
end


#Below is a test for correctness on points/number of nodes
def testLego( x, y, z, n1, n2 )
  test = Lego.new( x, y, z, n1, n2 )
  puts "Printing inputed values\n"
#
  puts "Testing node numbers"
  puts test.nodes1
  puts test.nodes2  
#
  puts "Printing point values"
  puts test.pt1[0]
  puts test.pt1[1]
  puts test.pt1[2]
  puts test.pt2[0]
  puts test.pt2[1]
  puts test.pt2[2]
  puts test.pt3[0]
  puts test.pt3[1]
  puts test.pt3[2]
  puts test.pt4[0]
  puts test.pt4[1]
  puts test.pt4[2]
#
  puts "Testing length/width"
  puts test.length
  puts test.width
#
  puts "Testing center values"
  puts test.centerL
  puts test.centerW
end


#orientation:
#


