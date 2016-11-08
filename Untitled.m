clear
clc

	% Read the reactants and products.
	rcnt_withNo = regexp('2a + b ', '\s+\+\s+', 'split' )
	i = 1;
	iMax = size(rcnt_withNo,2);
	rcnt = {''};
	while i <= iMax
		temp = regexp(rcnt_withNo{i},'(^[0-9]+)(\w*)','tokens')
		if isempty( temp)
			rcnt = [rcnt,rcnt_withNo{i}];
			i = i + 1;
			continue;
		else
			a = temp{1}(2)
			b = str2num(temp{1}{1})
			repmat( a,1,b)
			rcnt
			rcnt = [rcnt,repmat( temp{1}(2),1,str2num(temp{1}{1}))];
		end
		i = i + 1;
	end
