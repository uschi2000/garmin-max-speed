module GpsMath {

	function intersection(lx, ly, rx, ry, bx, by, headingx, headingy) {
		var intersection = check_if_two_points_same(lx, ly, rx, ry, bx, by);
		
		if (intersection == false) {
			var a_num = ((lx - bx + 0.0) * headingy - (ly - by) * headingx); 
			var a_denom = (headingy * (rx - lx) - headingx * (ry - ly));
			
			if (a_denom == 0) {
				return null; 
			} else {
				var intersectionx = lx - a_num / a_denom * (rx - lx);
				var intersectiony = ly - a_num / a_denom * (ry - ly);
				return [intersectionx, intersectiony];
			}
			
		} else {
			var intersectionx = intersection[0];
			var intersectiony = intersection[1];
			
			return [intersectionx, intersectiony];
		}	
	}
	
	function check_if_two_points_same(lx, ly, rx, ry, bx, by) {
		if (lx == rx && ly == ry) {
			return [lx, ly];
		} else if (lx == bx && ly == by) { 
			return [lx, ly];
		} else if (bx == rx && by == ry) {
			return [rx, ry];
		} else {
			return false;
		}
	}
	
	(:test)
	function intersection_orthogonal(logger) {
		var intersection = intersection(0, 2, 2, 2, 1, 0, 0, 1);
		var actualx = intersection[0];
		var actualy = intersection[1];
		return actualx == 1 && actualy == 2;
	}
	
	(:test)
	function intersection_45degrees(logger) {
		var intersection = intersection(0, 2, 2, 2, 0, 0, 1, 1);
		var actualx = intersection[0];
		var actualy = intersection[1];
		return actualx == 2 && actualy == 2;
	}
	
	(:test)
	function intersection_boat_on_starting_line(logger) {
		var intersection = intersection(0, 2, 2, 2, 1, 2, 1, 1);
		var actualx = intersection[0];
		var actualy = intersection[1];
		return actualx == 1 && actualy == 2;
	}
	
	(:test)
	function intersection_two_points_the_same(logger) {
		var intersection = intersection(0, 2, 0, 2, 0, 0, 1, 0);
		var actualx = intersection[0];
		var actualy = intersection[1];
		return actualx == 0 && actualy == 2;
	}

	(:test)
	function intersection_parallel(logger) {
		var intersection = intersection(0, 2, 2, 2, 1, 0, 1, 0);
		return intersection == null;
	}

}