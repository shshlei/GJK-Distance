function [dist, p1, p2] = GJK_distV(shape1, shape2, iterations, tol)
	[flag, simplex] = GJK(shape1, shape2, iterations);
	if flag
		dist = 0;
		p1 = [];
		p2 = [];
		return;
	end
	A = simplex.a;
	A1 = simplex.a1;
	A2 = simplex.a2;
	[C, IA] = unique(A', 'rows', 'stable');
	C = C';
	if (length(IA) == 1)
		a = C; a1 = A1(:,IA); a2 = A2(:,IA);
		len = 1;
	elseif (length(IA) == 2)
		a = C(:,1); a1 = A1(:,IA(1)); a2 = A2(:,IA(1));
		b = C(:,2); b1 = A1(:,IA(2)); b2 = A2(:,IA(2));
		len = 2;
	elseif (length(IA) == 3)
		a = C(:,1); a1 = A1(:,IA(1)); a2 = A2(:,IA(1));
		b = C(:,2); b1 = A1(:,IA(2)); b2 = A2(:,IA(2));
		c = C(:,3); c1 = A1(:,IA(3)); c2 = A2(:,IA(3));
		len = 3;
	elseif (length(IA) == 4)
		a = A(:,1); a1 = A1(:,1); a2 = A2(:,1);
		b = A(:,2); b1 = A1(:,2); b2 = A2(:,2);
		c = A(:,3); c1 = A1(:,3); c2 = A2(:,3);
		d = A(:,4); d1 = A1(:,4); d2 = A2(:,4);
		len = 4;
	end
	
	last_dist = inf; distp = -inf;
	if (len == 1)
		closest_p = a;
		dist = norm(closest_p);
	elseif (len == 2)
		[dist, closest_p] = distancePointLine3d([0;0;0], a, b);
	elseif (len == 3)
		[dist, closest_p] = pointTriangleDistance([a';b';c'], [0;0;0]);
		closest_p = closest_p';
	else
		[dist, closest_p, a, b, c, a1, b1, c1, a2, b2, c2] = simplexReduceToTriangle(a, b, c, d, ...
																					 a1, b1, c1, d1, ...
																					 a2, b2, c2, d2, last_dist);
		closest_p = closest_p';
		len = 3;
	end
		
	for i=1:iterations
		dir = -closest_p/norm(closest_p);
		[last, last1, last2] = support_2(shape1, shape2, dir);

		last_dist = dist;
		temp = last - closest_p;
		distp = max(last_dist - dir'*temp, distp);
		temp = temp/norm(temp);
		if last'*temp <= 0
			closest_p = last;
		else
			closest_p = last - last'*temp*temp;
		end
		dist = norm(closest_p);
       
		if (abs(last_dist - dist) < tol || dist - distp < tol)
			break;
		end
	end
end

function [dist, witness, ao, bo, co, a1, b1, c1, a2, b2, c2] = simplexReduceToTriangle(a, b, c, d, a1, b1, c1, d1, a2, b2, c2, d2, last_dist)
	best = -1;
	i = 0;
	[dist, witness] = pointTriangleDistance([a';b';c'], [0;0;0]);
	if (dist <= last_dist)
		last_dist = dist;
		best = i;
		best_witness = witness;
	end
	
	i = 1;
	[dist, witness] = pointTriangleDistance([a';b';d'], [0;0;0]);
	if (dist <= last_dist)
		last_dist = dist;
		best = i;
		best_witness = witness;
	end
	
	i = 2;
	[dist, witness] = pointTriangleDistance([b';c';d'], [0;0;0]);
	if (dist <= last_dist)
		last_dist = dist;
		best = i;
		best_witness = witness;
	end
	
	i = 3;
	[dist, witness] = pointTriangleDistance([a';c';d'], [0;0;0]);
	if (dist <= last_dist)
		last_dist = dist;
		best = i;
		best_witness = witness;
	end

	if best == 0
		ao = a; bo = b; co = c;
		a1 = a1; b1 = b1; c1 = c1;
		a2 = a2; b2 = b2; c2 = c2;
	elseif best ==1
		ao = a; bo = b; co = d;
		a1 = a1; b1 = b1; c1 = d1;
		a2 = a2; b2 = b2; c2 = d2;
	elseif best == 2
		ao = b; bo = c; co = d;
		a1 = b1; b1 = c1; c1 = d1;
		a2 = b2; b2 = c2; c2 = d2;
	elseif best == 3
		ao = a; bo = c; co = d;
		a1 = a1; b1 = c1; c1 = d1;
		a2 = a2; b2 = c2; c2 = d2;
	end
	
	witness = best_witness;
	dist = last_dist;
end

function [p1, p2] = extractObjectPointsFromSegment(a, b, a1, b1, a2, b2, p)
	ab = b - a;
	[v, ind] = max(abs(ab));
	if v < eps
		p1 = a1;
		p2 = a2;
	end	
	a_i = a(ind);
	ab_i = ab(ind);
	p_i = p(ind);
	  
	s = (p_i - a_i)/ab_i;
	p1 = a1 + s*(b1 - a1);
	p2 = a2 + s*(b2 - a2);
end

function [p1, p2] = extractObjectPointsFromTriangle(a, b, c, a1, b1, c1, a2, b2, c2, p)	  
    if (triangle_area_is_zero(a, b, c))
		[v, ind] = max([norm(b-a) norm(c-a) norm(c-b)]);
		if ind == 1
			[p1, p2] = extractObjectPointsFromSegment(a, b, a1, b1, a2, b2, p)
		elseif ind == 2
			[p1, p2] = extractObjectPointsFromSegment(a, c, a1, c1, a2, c2, p)
		else
			[p1, p2] = extractObjectPointsFromSegment(b, c, b1, c1, b2, c2, p)
		end
		return;
    end

    ab = b - a;
	ac = c - a;
	n  = cross(ab, ac);
	n2 = n'*n;

    ap = p - a;
	apac = cross(ap, ac);
	abap = cross(ab, ap);
	beta = n'*apac/n2;
	gamma = n'*abap/n2;

	p1 = a1 + beta*(b1 - a1) + gamma*(c1 - a1);
	p2 = a2 + beta*(b2 - a2) + gamma*(c2 - a2);
end

function res = triangle_area_is_zero(a, b, c)
	res = false;
	ab = (b-a)/norm(b-a);
	ac = (c-a)/norm(c-a);
	if (max(abs(ab))<eps || max(abs(ac))<eps)
		res = true;
		return;
	end

	n = cross(ab, ac);
	if norm(n) < eps
		res = true;
	end
end













