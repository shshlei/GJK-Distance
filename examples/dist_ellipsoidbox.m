clear all; close all; clc

shape1.type = 'ellipsoid';
shape1.a = 3; shape1.b = 4; shape1.c = 5;

shape2.type = 'box';
shape2.a = 5; shape2.b = 5; shape2.c = 5;

% visualization
[xe, ye, ze] = ellipsoid(0, 0, 0, 3.0, 4.0, 5.0);
sze = size(xe, 1);
Xe = [reshape(xe, 1, []); reshape(ye, 1, []); reshape(ze, 1, [])];

% box half length
a = 0.5 * shape2.a; b = 0.5 * shape2.b; c = 0.5 * shape2.c; 

% box vertices
verts=[-a -b -c;
		a -b -c;
		a  b -c;
		-a b -c;
		-a -b c;
		a -b c;
		a  b c;
		-a b c];

% box faces
faces=[1 2 3 4;
       1 2 6 5;
       2 3 7 6;
       3 4 8 7;
       4 1 5 8;
       5 6 7 8];

fig = figure;
hold on
S2Obj = patch('Faces', faces, 'Vertices', verts, 'Facecolor', 'c');
S2Coords = S2Obj.Vertices;

axis equal
range = 30;
axis([-10 range -10 range -10 range])
fig.Children.Visible = 'off'; % Turn off the axis for more pleasant viewing.
fig.Color = [1 1 1];
rotate3d on;

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
		he = surf(xed, yed, zed);
		hold on
		
		S2Obj.Vertices = (shape2.R*S2Coords')' + repmat(shape2.t', size(S2Obj.Vertices, 1), 1);
		axis([-10 range -10 range -10 range])	
		drawnow;

		[dist, p1, p2] = GJK_dist(shape1, shape2, iterations, tol);
		
		s1 = scatter3(p1(1), p1(2), p1(3), 50, 'r', 'filled');
		s2 = scatter3(p2(1), p2(2), p2(3), 50, 'b', 'filled');
		l1 = plot3([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)], 'LineWidth', 2);
		
		pause(0.2)
		delete(he)
		delete(s1)
		delete(s2)
		delete(l1)
	end
end