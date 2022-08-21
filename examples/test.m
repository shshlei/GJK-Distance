clear all; close all; clc

% shape1.type = 'ellipsoid';
% shape1.a = 3; shape1.b = 4; shape1.c = 5;
% shape1.R = rotx(2*pi*rand())*roty(2*pi*rand())*rotz(2*pi*rand());
% shape1.t = [100+1.0*rand(); 100+3.5*rand(); 100+5.0*rand()];

shape1.type = 'box';
shape1.a = 3.5; shape1.b = 2.5; shape1.c = 1.5;
shape1.R = rotx(2*pi*rand())*roty(2*pi*rand())*rotz(2*pi*rand());
%shape1.R = eye(3);
%shape1.t = [100+5.0*rand();100+3.5*rand();100+1.0*rand()];
shape1.t = [100;100;0];

shape2.type = 'box';
shape2.a = 3.5; shape2.b = 2.5; shape2.c = 1.5;
%shape2.R = rotx(2*pi*rand())*roty(2*pi*rand())*rotz(2*pi*rand());
shape2.R = eye(3);
%shape2.t = [200+5.0*rand();200+3.5*rand();200+1.0*rand()];
shape2.t = [200;200;0];

loop = 1

%% shape1
origin = [0; 0; 0];
%dir = [2*rand()-1; 2*rand()-1; 2*rand()-1];
dir = [1;1;1];
dir = dir/norm(dir);
point1 = support_1(shape1, dir);
for i=1:loop
	point = point1;
	dir = -point/norm(point);

	point1 = support_1(shape1, dir);
	d1 = -point1'*dir;
	dir = -point1/norm(point1);

	point2 = support_1(shape1, dir);
	d2 = -point2'*dir;
	%dir = -point2/norm(point2);
end

t = linspace(0,1,101);
for i=1:101
	p = (1.0 - t(i)) * point + t(i) * point1;
	dir = -p/norm(p);
	pp = support_1(shape1, dir);
	d(i) = -pp'*dir;
end
figure
plot(t,d)
hold on
scatter(0, d(1))
scatter(1, d(101))
[dist, p] = distancePointLine3d(origin, point, point1);
dir = -p/norm(p);
pp = support_1(shape1, dir);
dd = -pp'*dir;
plot([0 1],[dd dd])

%% shape2
origin = [0; 0; 0];
%dir = [2*rand()-1; 2*rand()-1; 2*rand()-1];
dir = [1;1;1];
dir = dir/norm(dir);
point1 = support_1(shape2, dir);
for i=1:loop
	point = point1;
	dir = -point/norm(point);

	point1 = support_1(shape2, dir);
	d1 = -point1'*dir;
	dir = -point1/norm(point1);

	point2 = support_1(shape2, dir);
	d2 = -point2'*dir;
	%dir = -point2/norm(point2);
end

t = linspace(0,1,101);
for i=1:101
	p = (1.0 - t(i)) * point + t(i) * point1;
	dir = -p/norm(p);
	pp = support_1(shape2, dir);
	d(i) = -pp'*dir;
end
figure
plot(t,d)
hold on
scatter(0, d(1))
scatter(1, d(101))
[dist, p] = distancePointLine3d(origin, point, point1);
dir = -p/norm(p);
pp = support_1(shape2, dir);
dd = -pp'*dir;
plot([0 1],[dd dd])

%% shape1 - shape2
origin = [0; 0; 0];
%dir = [2*rand()-1; 2*rand()-1; 2*rand()-1];
dir = [1;1;1];
dir = dir/norm(dir);
point1 = support_2(shape1, shape2, dir);
for i=1:loop
	point = point1;
	dir = -point/norm(point);

	point1 = support_2(shape1, shape2, dir);
	d1 = -point1'*dir;
	dir = -point1/norm(point1);

	point2 = support_2(shape1, shape2, dir);
	d2 = -point2'*dir;
	%dir = -point2/norm(point2);
end

t = linspace(0,1,101);
for i=1:101
	p = (1.0 - t(i)) * point + t(i) * point1;
	dir = -p/norm(p);
	pp = support_2(shape1, shape2, dir);
	d(i) = -pp'*dir;
end
figure
plot(t,d)
hold on
scatter(0, d(1))
scatter(1, d(101))
[dist, p] = distancePointLine3d(origin, point, point1);
dir = -p/norm(p);
pp = support_2(shape1, shape2, dir);
dd = -pp'*dir;
plot([0 1],[dd dd])