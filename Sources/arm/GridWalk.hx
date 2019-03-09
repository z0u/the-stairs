package arm;

import armory.trait.physics.RigidBody;
import iron.math.Vec4;
import iron.math.Math;


class GridWalk extends iron.Trait {
	static inline var GRID_SIZE = 0.25;

	public function new() {
		super();
		notifyOnInit(init);
		notifyOnUpdate(step);
	}

	function init() {
		this.object.transform.loc = snap_to_grid(this.object.transform.loc);
		this.object.transform.buildMatrix();
	}

	function step() {
		var move = this.object.properties['move'];
		if (!move) return;
		applyMovement(move);
	}

	function applyMovement(move:String) {
		var vec = new Vec4();
		if (move == '+y') vec.y = GRID_SIZE;
		else if (move == '-y') vec.y = -GRID_SIZE;
		else if (move == '+x') vec.x = GRID_SIZE;
		else if (move == '-x') vec.x = -GRID_SIZE;
		this.object.transform.loc.add(vec);
		this.object.transform.loc = snap_to_grid(this.object.transform.loc);
		this.object.transform.buildMatrix();

		#if arm_physics
		var rigidBody = object.getTrait(RigidBody);
		if (rigidBody != null) rigidBody.syncTransform();
		#end
	}

	function snap_to_grid(loc:Vec4):Vec4 {
		var up = this.object.transform.up();
		var halfStep = GRID_SIZE * 0.5;
		var origin:Vec4;
		if (up.x > 0.9 || up.x < -0.9)
			// Z aligned with world X
			origin = new Vec4(0, halfStep, halfStep, 0);
		else if (up.y > 0.9 || up.y < -0.9)
			// Z aligned with world Y
			origin = new Vec4(halfStep, 0, halfStep, 0);
		else
			// Z aligned with world Z
			origin = new Vec4(halfStep, halfStep, 0, 0);

		var offsetM = loc.sub(origin);
		var offsetCells = offsetM.mult(1 / GRID_SIZE);
		offsetCells.x = Math.round(offsetCells.x);
		offsetCells.y = Math.round(offsetCells.y);
		offsetCells.z = Math.round(offsetCells.z);
		offsetM = offsetCells.mult(GRID_SIZE);
		return origin.add(offsetM);
	}
}
