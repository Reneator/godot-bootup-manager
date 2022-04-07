# godot-bootup-manager
A BootupManager Autoload script which helps you organize bootup order/priorities by having 2 core functions:

The BootupManager (Bootup_Manager.gd) needs to be added as Autoload-Script to your project by going to: Project -> Projectsettings -> Autoload Tab -> open file
The Script is self-containing and has all classes it needs inside itself.

This concept has proven very helpful to me, so im sharing it here to see if others also find it useful

It uses 2 main methods:

- `get_or_connect(element_id: String, node_to_call : Node, method_name_to_call : String, (optional) priority: int )`: either calls the method given on the node when the node for the element-id (for example "player") is already registered or when it registers later on.

- `register(element_id: String, node_to_register : Node)`: registers a node with the BootupManager to be available under the element_id. Will call all the systems/nodes that connected via get_or_connect and the correct element_id. can currently only be called once.

For example on how to use, clone the repo and start the "Example_Scene.tscn" (Or just the project directly)

More descriptions in the comments and examples.

Any feedback/critique/ideas are appreciated
