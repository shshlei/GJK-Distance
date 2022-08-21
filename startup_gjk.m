disp('GJK algorithms');

gjkpath = fileparts( mfilename('fullpath') );

shapespath = fullfile(gjkpath, 'shapes');
if exist(shapespath,'dir')
    addpath(shapespath);
end

distpath = fullfile(gjkpath, 'dist');
if exist(distpath,'dir')
    addpath(distpath);
end

GJKpath = fullfile(gjkpath, 'GJK');
if exist(GJKpath,'dir')
    addpath(GJKpath);
end

examplespath = fullfile(gjkpath, 'examples');
if exist(examplespath,'dir')
    addpath(examplespath);
end

clear gjkpath shapespath distpath GJKpath examplespath
