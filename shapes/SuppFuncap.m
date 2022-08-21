function [Spoint] = SuppFuncap(l, r, u)
	% Support function of a cap.
	% v is a unit vector
	height = l/2.0;
	if u(3)>0
		Spoint = [0;0;height] + r*u;
	else
		Spoint = [0;0;-height] + r*u;
	end
end