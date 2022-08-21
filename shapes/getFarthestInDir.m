function point = getFarthestInDir(shape, v)
	%Find the furthest point in a given direction for a shape
	XData = shape.Vertices(:,1); % Making it more compatible with previous MATLAB releases.
	YData = shape.Vertices(:,2);
	ZData = shape.Vertices(:,3);
	dotted = XData*v(1) + YData*v(2) + ZData*v(3);
	[maxInCol,rowIdxSet] = max(dotted);
	[maxInRow,colIdx] = max(maxInCol);
	rowIdx = rowIdxSet(colIdx);
	point = [XData(rowIdx,colIdx), YData(rowIdx,colIdx), ZData(rowIdx,colIdx)]';
end