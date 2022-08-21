function point = support_1(shape, v)
	% Support function to get the Minkowski difference.
	% v is a unit vector
	switch lower(shape.type)
		case 'mesh'
			if size(shape.Vertices,1)==1
				point=shape.Vertices(1,:)';
			else
				point = getFarthestInDir(shape, v);
			end
		case 'sphere'
			t = shape.t;
			r = shape.r;
			point = r*v + t;
		case 'ellipsoid'
			R = shape.R; t = shape.t;
			a = shape.a; b = shape.b; c = shape.c;
			vre    = R'*v;
			point = SuppFunellipsoid(a, b, c, vre);
			point = R*point + t;
		case 'box'
			R = shape.R; t = shape.t;
			a = shape.a; b = shape.b; c = shape.c;
			vre    = R'*v;
			point = SuppFunbox(a, b, c, vre);
			point = R*point + t;
		case 'cap'
			R = shape.R; t = shape.t;
			l = shape.l; r = shape.r;
			vre    = R'*v;
			point = SuppFuncap(l, r, vre);
			point = R*point + t;
	end
end