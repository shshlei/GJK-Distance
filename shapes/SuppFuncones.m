function [Spoint] = SuppFuncones(z0, z1, u)
	% Support function of a convex cone.
	% v is a unit vector
	eu = u/norm(u);
	if eu(3) <= -sqrt(2.0)/2.0
		Spoint = z0*[eu(1); eu(2); 1];
	else
		Spoint = z1*[eu(1); eu(2); 1];
	end
	
	%Svalue = Spoint'*u;
end