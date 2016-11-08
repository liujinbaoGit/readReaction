function [ rcnt, prdt, dEg ] = readRcPr( inputStr )
%% readRcPr [Version_16.11.07]
% ----------------------------------------------------------------------------------
% 	Read a reaction str, then export the reactant and product in
%	cell. It must have '\s*=>\s*'(not <=>) and use '\s+\+\s+' to split
%	the reactants and products.
%	The energy unit is 'eV';
%	'[A-Z][^\s]*'		the regular expression of a specie which must start with a
%						uppercase letter.
%	e.g.	inputStr	'O4^- + NO^+ 3_eV  => O2 + O2 + NO'
%			rcnt		{ 'O4^-', 'NO^+'}		cell( 1 x 2 )
%			prdt		{ 'O2', 'O2', 'NO' }	cell( 1 x 3 )
%			dEg  		-3
% **********************************************************************************
if ~ischar(inputStr)
	error('The input is not a char array.');
elseif ~contains(inputStr,'=>')
	error('The input is not a reaction.');
elseif contains(inputStr,'<=>')
	error('The <=> should be replaced with =>.');
else
	str = shortenStr(inputStr);
	rctnStr = regexp(str,'\s*=>\s*','split');

	rcntStr = rctnStr{1};
	prdtStr = rctnStr{2};

	% Read the dEg.
	dEgStr1 = regexp( rcntStr, '([^\s]+)_eV', 'tokens');
	dEgStr2 = regexp( prdtStr, '([^\s]+)_eV', 'tokens');
	if ~isempty(dEgStr1)
		dEg = -1*str2num(dEgStr1{1}{:});
		rcntStr = erase( rcntStr, [dEgStr1{1}{:},'_eV'] );
	elseif ~isempty(dEgStr2)
		dEg = str2num(dEgStr2{1}{:});
		prdtStr = erase( prdtStr, [dEgStr2{1}{:},'_eV'] );
	else
		dEg = 0;
	end

	% Read the reactants and products.
	rcnt_withNo = regexp(rcntStr, '\s+\+\s+', 'split' );
	i = 1;
	iMax = size(rcnt_withNo,2);
	rcnt = {''};
	while i <= iMax
		temp = regexp(rcnt_withNo{i},'(^[0-9]+)(\w*)','tokens');
		if isempty( temp)
			rcnt = [rcnt,rcnt_withNo{i}];
			i = i + 1;
			continue;
		else
			rcnt = [rcnt,repmat( temp{1}(2),1,str2num(temp{1}{1}))];
		end
		i = i + 1;
	end
	rcnt = rcnt(1,2:end);

	prdt_withNo = regexp(prdtStr, '\s+\+\s+', 'split' );
	i = 1;
	iMax = size(prdt_withNo,2);
	prdt = {''};
	while i <= iMax
		temp = regexp(prdt_withNo{i},'(^[0-9]+)(\w*)','tokens');
		if isempty( temp)
			prdt = [prdt,prdt_withNo{i}];
			i = i + 1;
			continue;
		else
			prdt = [prdt,repmat( temp{1}(2),1,str2num(temp{1}{1}))];
		end
		i = i + 1;
	end
	prdt = prdt(1,2:end);
end
end

