clear all; close all; clc

shape1.type = 'ellipsoid';
shape1.a = 3; shape1.b = 4; shape1.c = 5;

shape2.type = 'sphere';
shape2.r = 5;

% rotation and translation
shape1.R = eye(3);
shape1.t = [0; 0; 0];
shape2.R = eye(3);
shape2.t = [0; 0; 0];
flag = GJK(shape1, shape2, 100);
if ~flag
	error('The GJK algorithm is error!');
end

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
for i=1:3000
	shape1.R = rotx(2*pi*rand())*roty(2*pi*rand())*rotz(2*pi*rand());
	shape1.t = range*[rand(); rand(); rand()];
	
	Xed = shape1.R * Xe + repmat(shape1.t, 1, size(Xe, 2));
	xed = reshape(Xed(1,:), sze, sze);
	yed = reshape(Xed(2,:), sze, sze);
	zed = reshape(Xed(3,:), sze, sze);	
	surf(xed, yed, zed);
	hold on

	shape2.R = rotx(2*pi*rand())*roty(2*pi*rand())*rotz(2*pi*rand());
	shape2.t = range*[rand(); rand(); rand()];
	
	Xsd = shape2.R * Xs + repmat(shape2.t, 1, size(Xs, 2));
	xsd = reshape(Xsd(1,:), szs, szs);
	ysd = reshape(Xsd(2,:), szs, szs);
	zsd = reshape(Xsd(3,:), szs, szs);
	surf(xsd, ysd, zsd);
	drawnow;
	axis([-10 range -10 range -10 range])
	
	flag = GJK(shape1, shape2, iterations);

	if flag
		t = text(3,3,3,'Collision!','FontSize',30);
		break;
	end
	
	pause(0.2)
	
	clf
end