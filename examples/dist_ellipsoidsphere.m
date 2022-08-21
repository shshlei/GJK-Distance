clear all; close all; clc

shape1.type = 'ellipsoid';
shape1.a = 3; shape1.b = 4; shape1.c = 5;

shape2.type = 'sphere';
shape2.r = 5;

% visualization
[xs, ys, zs] = sphere;
xs = 5.0 * xs; ys = 5.0 * ys; zs = 5.0 * zs;
[xe, ye, ze] = ellipsoid(0, 0, 0, 3.0, 4.0, 5.0);

szs = size(xs, 1);
sze = size(xe, 1);
Xs = [reshape(xs, 1, []); reshape(ys, 1, []); reshape(zs, 1, [])];
Xe = [reshape(xe, 1, []); reshape(ye, 1, []); reshape(ze, 1, [])];

fig = figure;
axis equal
range = 50;
axis([-10 range -10 range -10 range])
fig.Children.Visible = 'off'; % Turn off the axis for more pleasant viewing.
fig.Color = [1 1 1];
rotate3d on;
hold on

iterations = 100;
tol = 1.e-6;
for i=1:100
	shape1.R = rotx(2*pi*rand())*roty(2*pi*rand())*rotz(2*pi*rand());
	shape1.t = range*[rand(); rand(); rand()];
	
	shape2.R = rotx(2*pi*rand())*roty(2*pi*rand())*rotz(2*pi*rand());
	shape2.t = range*[rand(); rand(); rand()];
	
	flag = GJK(shape1, shape2, iterations);

	if ~flag
		Xed = shape1.R * Xe + repmat(shape1.t, 1, size(Xe, 2));
		xed = reshape(Xed(1,:), sze, sze);
		yed = reshape(Xed(2,:), sze, sze);
		zed = reshape(Xed(3,:), sze, sze);	
		surf(xed, yed, zed);
		hold on
		
		Xsd = shape2.R * Xs + repmat(shape2.t, 1, size(Xs, 2));
		xsd = reshape(Xsd(1,:), szs, szs);
		ysd = reshape(Xsd(2,:), szs, szs);
		zsd = reshape(Xsd(3,:), szs, szs);
		surf(xsd, ysd, zsd);
		drawnow;
		axis([-10 range -10 range -10 range])
	
		[dist, p1, p2] = GJK_dist(shape1, shape2, iterations, tol);
		scatter3(p1(1), p1(2), p1(3), 50, 'r', 'filled')
		scatter3(p2(1), p2(2), p2(3), 50, 'b', 'filled')
		plot3([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)], 'LineWidth', 2)
		pause(0.35)
		clf		
	end
end