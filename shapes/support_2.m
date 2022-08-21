function [point, point1 ,point2] = support_2(shape1, shape2, v)
	% Support function to get the Minkowski difference.
	% v is a unit vector
	point1 = support_1(shape1, v);
	point2 = support_1(shape2, -v);
	point = point1 - point2;
end