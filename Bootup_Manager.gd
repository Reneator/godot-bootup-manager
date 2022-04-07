extends Node
#register as Auto-load script


# manages the bootup-signalling for systems that can have a longer bootup
# so instead of having to add this functionality to each node that needs the information
# i can just handle the behaviour in this class
# especially useful for complex Game-scenes with complex initializing behaviour that depend on other
# nodes that need to be fully ready/initialized when the node depending on it is trying to start working
# This can save you from having to create fixed calls and gets/searches in the tree and you can 
# build a reliable and easy to maintain way to set up bootup-order of nodes/scenes/systems

# I know you could structure your entire project around this, but this will give you more creative
# freedom and flexibility imo instead of having to keep to a strict initialization order
# via pure signal or scene-structure

var elements = {} #element_id:element (

var registrants = {} #element_id: [{registrant, method_name}]

func _ready():
	#hookup to an event where the game is being loaded to clear up the boot-manager
	#Events.connect("on_game_load",self,"on_game_load")
	pass

func on_game_load():
	elements = {}
	registrants = {}


#When the node for the element_id already exists, the method for the registrant will be immediately called
#If not, it will be added as registrant 
#priority is optional and can be used if you need a fixed order of initialization of nodes
#on when the node registers itself
"""Use this function to connect nodes to certain elements"""
func get_or_connect(element_id : String, registrant : Node, method_name : String, priority : int = 0):
	
	if not registrant:
		print("No registrant given")
		assert(false)
		
	if not registrant.has_method(method_name):
		print("Registrant %s doesnt have the function it wants to register with: %s" % [registrant.name, method_name])
		assert(false)
	
	if elements.has(element_id):
		var element = elements[element_id]
		registrant.call(method_name, element)
	else:
		add_registrant(element_id, registrant, method_name, priority)

#adds a node as registrant which will be called when the registering node calls "register"
#this one should not be called directly
func add_registrant(element_id : String, registrant : Node, method_name : String, priority : int = 0):
	var new_registrant = Bootup_Manager_Registrant.new()
	new_registrant.registrant = registrant
	new_registrant.method_name = method_name
	new_registrant.priority = priority
	
	if registrants.has(element_id):
		var registrants_for_element_id = registrants[element_id]
		registrants_for_element_id.append(new_registrant)
	else:
		var new_list = []
		new_list.append(new_registrant)
		registrants[element_id] = new_list

#register a node that registrants are currently waiting for
"""Use this function to register nodes that the registrants depend upon"""
func register(element_id : String, element : Object):
	if elements.has(element_id):
		return
	else:
		elements[element_id] = element
	
	var registrants_for_element = registrants.get(element_id)
	if not registrants_for_element:
		return
		
	registrants_for_element.sort_custom(Bootup_Manager_Sorter, "sort")
	for registrant in registrants_for_element:
		registrant.call(element)

class Bootup_Manager_Sorter:
	static func sort(a : Bootup_Manager_Registrant, b: Bootup_Manager_Registrant):
		if int(a.priority) < int(b.priority):
			return true
		return false

class Bootup_Manager_Registrant:
	var registrant : Node
	var method_name : String
	var priority

	func call(element):
		registrant.call(method_name, element)
