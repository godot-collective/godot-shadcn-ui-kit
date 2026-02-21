@tool
extends EditorScript

const SOURCE_SCENE := "res://main.tscn"
const TARGET_SCENE := "res://main_static.tscn"


func _run() -> void:
	var source := load(SOURCE_SCENE) as PackedScene
	if source == null:
		push_error("Cannot load source scene: %s" % SOURCE_SCENE)
		return

	var root := source.instantiate() as Control
	if root == null:
		push_error("Source root is not a Control.")
		return

	# Build exactly the same UI tree as the runtime code version.
	root.call("_apply_theme")
	root.call("_build_gallery")
	root.size = Vector2(1500, 920)
	root.call("_sync_layout")
	root.call("_update_columns")

	# Convert to static scene: remove script and persist generated children.
	root.name = "GalleryStatic"
	root.set_script(null)
	_assign_owner_recursive(root, root)

	var packed := PackedScene.new()
	var pack_err := packed.pack(root)
	if pack_err != OK:
		push_error("Pack failed: %s" % error_string(pack_err))
		return

	var save_err := ResourceSaver.save(packed, TARGET_SCENE)
	if save_err != OK:
		push_error("Save failed: %s" % error_string(save_err))
		return

	print("Baked static scene: %s" % TARGET_SCENE)


func _assign_owner_recursive(node: Node, owner: Node) -> void:
	for child in node.get_children():
		child.owner = owner
		_assign_owner_recursive(child, owner)
