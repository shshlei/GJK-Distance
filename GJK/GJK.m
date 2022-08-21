function [flag, simplex] = GJK(shape1, shape2, iterations)
	% GJK Gilbert-Johnson-Keerthi Collision detection implementation.
	% Returns whether two convex shapes are are penetrating or not
	% (true/false). Only works for CONVEX shapes.
	%
	%   Shi Shenglei, 2018
	%
	
	origin = [0; 0; 0];
    dir = [1; 1; 1]; dir = dir/norm(dir);
	[last, last1, last2] = support_2(shape1, shape2, dir);
	simplex.a = last; simplex.a1 = last1; simplex.a2 = last2; 
    dir = -last;
    for i=1:iterations
		if max(abs(dir))<eps
			flag = 1;
			return;
		end
        dir = dir/norm(dir);
		[last, last1, last2] = support_2(shape1, shape2, dir);
		simplex.a = [simplex.a last]; simplex.a1 = [simplex.a1 last1]; simplex.a2 = [simplex.a2 last2]; 
        if dir'*last < 0
            flag = 0;
			return;
		end

        [do_simplex_res, dir, simplex] = doSimplex(simplex);
        if do_simplex_res == 1
            flag = 1;
			return;
        elseif do_simplex_res == -1
			flag = 0;
            return;
        end
	end

    flag = 0;
end

function [do_simplex_res, dir, simplex] =  doSimplex(simplex)
	if size(simplex.a, 2) == 2
		[do_simplex_res, dir, simplex] =  doSimplex2(simplex);
	elseif size(simplex.a, 2) == 3
		[do_simplex_res, dir, simplex] =  doSimplex3(simplex);
	else
		[do_simplex_res, dir, simplex] =  doSimplex4(simplex);
	end
end

function [do_simplex_res, dir, simplex] = doSimplex2(simplex)
	simplex = simplex;
	p_OA = simplex.a(:, 2);
	p_OB = simplex.a(:, 1);
	if p_OA'*p_OB > p_OB'*p_OB*eps
		error('A is not in region 1');
	end
	
	p_AB = p_OB - p_OA;
	plane_normal = cross(p_OB, p_AB);

	if plane_normal'*plane_normal < p_AB'*p_AB * p_OB'*p_OB * eps * eps
		do_simplex_res = 1; dir = [];
		return;
	end

	dir = cross(plane_normal/norm(plane_normal), p_AB);
	do_simplex_res = 0;
end

function [do_simplex_res, dir, simplex] = doSimplex3(simplex)
    origin = [0; 0; 0];
	simplex = simplex;
	A = simplex.a(:, 3); B = simplex.a(:, 2); C = simplex.a(:, 1); 

	[dist, PP0] = pointTriangleDistance([A'; B'; C'], origin);
	if dist*dist < eps*eps
		do_simplex_res = 1; dir = [];
		return;
	end
	
    AO = -A;
	AB = B - A;
	AC = C - A;
    ABC = cross(AB, AC);
	
	if max(abs(AB)) < eps || max(abs(AC))<eps
		do_simplex_res = -1; dir = [];
		return;
	end
	
	tmp = cross(ABC, AC);
    dot = tmp'*AO;
    if abs(dot)<eps || dot > 0
		dot = AC'*AO;
        if abs(dot)<eps || dot > 0
            simplex.a(:,2) = simplex.a(:,3); simplex.a(:,3) = [];
			simplex.a1(:,2) = simplex.a1(:,3); simplex.a1(:,3) = [];
			simplex.a2(:,2) = simplex.a2(:,3); simplex.a2(:,3) = [];
			dir = cross(cross(AC, AO), AC);
        else
            dot = AB'*AO;
            if abs(dot)<eps || dot > 0
                simplex.a(:,1) = simplex.a(:,2); simplex.a(:,2) = simplex.a(:,3); simplex.a(:,3) = [];
				simplex.a1(:,1) = simplex.a1(:,2); simplex.a1(:,2) = simplex.a1(:,3); simplex.a1(:,3) = [];
				simplex.a2(:,1) = simplex.a2(:,2); simplex.a2(:,2) = simplex.a2(:,3); simplex.a2(:,3) = [];
				dir = cross(cross(AB, AO), AB);
            else
                simplex.a(:,1) = simplex.a(:,3); simplex.a(:,2) = []; simplex.a(:,3) = [];
				simplex.a1(:,1) = simplex.a1(:,3); simplex.a1(:,2) = []; simplex.a1(:,3) = [];
				simplex.a2(:,1) = simplex.a2(:,3); simplex.a2(:,2) = [];simplex.a2(:,3) = [];
				dir = AO;
            end
        end
    else
		tmp = cross(AB, ABC);
        dot = tmp'*AO;
        if abs(dot)<eps || dot > 0
            dot = AB'*AO;
            if abs(dot)<eps || dot > 0
                simplex.a(:,1) = simplex.a(:,2); simplex.a(:,2) = simplex.a(:,3); simplex.a(:,3) = [];
				simplex.a1(:,1) = simplex.a1(:,2); simplex.a1(:,2) = simplex.a1(:,3); simplex.a1(:,3) = [];
				simplex.a2(:,1) = simplex.a2(:,2); simplex.a2(:,2) = simplex.a2(:,3); simplex.a2(:,3) = [];
				dir = cross(cross(AB, AO), AB);
            else
                simplex.a(:,1) = simplex.a(:,3); simplex.a(:,2) = []; simplex.a(:,3) = [];
				simplex.a1(:,1) = simplex.a1(:,3); simplex.a1(:,2) = []; simplex.a1(:,3) = [];
				simplex.a2(:,1) = simplex.a2(:,3); simplex.a2(:,2) = [];simplex.a2(:,3) = [];
				dir = AO;
            end
        else
			dot = ABC'*AO;
            if abs(dot)<eps || dot > 0
                dir = ABC;
            else
				atemp = simplex.a(:,1); a1temp = simplex.a1(:,1); a2temp = simplex.a2(:,1);
				simplex.a(:,1) = simplex.a(:,2); simplex.a(:,2) = atemp;
				simplex.a1(:,1) = simplex.a1(:,2); simplex.a1(:,2) = a1temp;
				simplex.a2(:,1) = simplex.a2(:,2); simplex.a2(:,2) = a2temp;
				dir = -ABC;
            end
        end
    end

    do_simplex_res = 0;
end

function [do_simplex_res, dir, simplex] = doSimplex4(simplex)
    origin = [0; 0; 0];
	simplex = simplex;
	A = simplex.a(:, 4); B = simplex.a(:, 3);
	C = simplex.a(:, 2); D = simplex.a(:, 1);

    [dist, PP0] = pointTriangleDistance([B'; C'; D'], A);
	if dist*dist < eps*eps
		do_simplex_res = -1; dir = [];
		return;
	end
	
	[dist, PP0] = pointTriangleDistance([A'; B'; C'], origin);
	if dist*dist < eps*eps
		do_simplex_res = 1; dir = [];
		return;
	end
    [dist, PP0] = pointTriangleDistance([A'; C'; D'], origin);
	if dist*dist < eps*eps
		do_simplex_res = 1; dir = [];
		return;
	end
    [dist, PP0] = pointTriangleDistance([A'; B'; D'], origin);
	if dist*dist < eps*eps
		do_simplex_res = 1; dir = [];
		return;
	end
    [dist, PP0] = pointTriangleDistance([B'; C'; D'], origin);
	if dist*dist < eps*eps
		do_simplex_res = 1; dir = [];
		return;
	end

    AO = -A;
    AB = B - A;
    AC = C - A;
    AD = D - A;
    ABC= cross(AB, AC);
    ACD= cross(AC, AD);
    ADB= cross(AD, AB);

	B_on_ACD = ccdSign(ACD'*AB);
    C_on_ADB = ccdSign(ADB'*AC);
    D_on_ABC = ccdSign(ABC'*AD);

    AB_O = (ccdSign(ACD'*AO) == B_on_ACD);
    AC_O = (ccdSign(ADB'*AO) == C_on_ADB);
    AD_O = (ccdSign(ABC'*AO) == D_on_ABC);

	
    if AB_O && AC_O && AD_O
        do_simplex_res =  1; dir = [];
        return;
    elseif ~AB_O
        simplex.a(:,3) = simplex.a(:,4); simplex.a(:,4) = [];
		simplex.a1(:,3) = simplex.a1(:,4); simplex.a1(:,4) = [];
		simplex.a2(:,3) = simplex.a2(:,4); simplex.a2(:,4) = [];
    elseif ~AC_O
		simplex.a(:,2) = simplex.a(:,1); simplex.a(:,1) = simplex.a(:,3); simplex.a(:,3) = simplex.a(:,4); simplex.a(:,4) = [];
		simplex.a1(:,2) = simplex.a1(:,1); simplex.a1(:,1) = simplex.a1(:,3); simplex.a1(:,3) = simplex.a1(:,4); simplex.a1(:,4) = [];
		simplex.a2(:,2) = simplex.a2(:,1); simplex.a2(:,1) = simplex.a2(:,3); simplex.a2(:,3) = simplex.a2(:,4); simplex.a2(:,4) = [];
    else
        simplex.a(:,1) = simplex.a(:,2); simplex.a(:,2) = simplex.a(:,3); simplex.a(:,3) = simplex.a(:,4); simplex.a(:,4) = [];
		simplex.a1(:,1) = simplex.a1(:,2); simplex.a1(:,2) = simplex.a1(:,3); simplex.a1(:,3) = simplex.a1(:,4); simplex.a1(:,4) = [];
		simplex.a2(:,1) = simplex.a2(:,2); simplex.a2(:,2) = simplex.a2(:,2); simplex.a2(:,3) = simplex.a2(:,4); simplex.a2(:,4) = [];
    end

    [do_simplex_res, dir] = doSimplex3(simplex);
end

function res = ccdSign(val)
	if max(abs(val)) < eps
        res = 0;
    elseif val < 0
        res = -1;
	else
		res = 1;
    end
end