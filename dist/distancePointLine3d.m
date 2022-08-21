function [dist, witness] = distancePointLine3d(point, x0, b)
	% Distance between a point and a line segment in 3D space.
	d = b - x0; nmd = norm(d);
	d = d/nmd;
    a = point - x0;
	t = a'*d;

	if (t<=0)
		witness = x0;
		dist = norm(a);
	elseif (t>=nmd)
		witness = b;
		dist = norm(point-b);
	else
		witness = x0 + t*d;
		dist = norm(point-witness);
	end
end