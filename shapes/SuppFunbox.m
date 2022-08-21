function [Spoint] = SuppFunbox(a, b, c, u)
	% Support function of a box.
	% v is a unit vector
	if u(1)>=0, sa = a/2.0;
	else sa = -a/2.0; end
	
	if u(2)>=0, sb = b/2.0;
	else sb = -b/2.0; end
	
	if u(3)>=0, sc = c/2.0;
	else sc = -c/2.0; end
	
	Spoint = [sa; sb; sc];
end