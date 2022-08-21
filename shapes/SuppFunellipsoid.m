function [Spoint] = SuppFunellipsoid(a, b, c, u)
	% Support function of an ellipsoid.
	% v is a unit vector
	Spoint = [a*a*u(1); b*b*u(2); c*c*u(3)];
	Spoint = Spoint/sqrt(u'*Spoint);
end