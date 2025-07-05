class_name AreaHelper

static func contiene_punto(area :Area2D,punto: Vector2) -> bool:
	if area == null:
		return false;
	for child in area.get_children():
		if child is CollisionShape2D and child.shape is RectangleShape2D:
			var shape: RectangleShape2D = child.shape;
			var global_xform: Transform2D = child.get_global_transform();
			var center: Vector2 = global_xform.origin;
			var extents: Vector2 = shape.extents;
			var topleft: Vector2 = center - extents;
			var rect: Rect2 = Rect2(topleft, extents * 2.0);
			
			if rect.has_point(punto):
				return true;
	return false;
