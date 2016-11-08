function [ spcs, rcntM, prdtM, kM, dEgM ] = readRctnList( fileName )
%% readRctnList [Version 16.11.08]
% ----------------------------------------------------------------------------------
%	Read a file that contains the reaction list.
%	The reaction has the following form
%		A + B => C + D ! 3e-9
%	a simplicity form:
%		@A + O2^- => @A + O2 + E 	! 2.18E-18
%		@A = O2 O2(V1) O2(V2) O2(V3) O2(V4)
%	The dEg could be embeded as a rcnt or prdt. It must ends with '_eV'.
%		A + B => C + D + 1.0_eV
% **********************************************************************************
fileID = fopen(fileName,'r');
% fileID = fopen('kinet_N2_O2_v1.03.inp','r');
strM = textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);
str = strM{:};
% ----------------------------------------------------------------------------------
%	Read the rctns(reactions with k and dEg) in str and replace the @* label
% ----------------------------------------------------------------------------------
rctns   = {''};
i = 1;
while i <= size(str,1)
	if startsWith( str(i), '#' )|startsWith( str(i), '%' )	% Comment line
		i = i + 1;
		continue;
	elseif ~contains( str{i}, {'=>','@'} )	%
		i = i + 1;
		continue;
	elseif contains( str{i}, '=>' )
		if ~contains( str{i}, '@' )	% a single reaction (with '=>', without '@')
			rctns(end+1,1) = str(i);
			i = i + 1;
			continue;
		else						% a group of reactions (with '=>', with '@')
			n = size(unique(regexp(str{i,1},'@\w','match')),2);	% amount of @*
			m = size(regexp(str{i+1,1},'[^\s]+','match'),2)-2;	% amount of list
			% replace the @* with the relevant term.
			tempM = {''};
			for j = 1:m
				temp = str{i,1};
				for k = 1:n
					sublist = regexp(str{i+k},'[^\s]+','match');
					new = sublist{2+j};
					temp = replace(temp,sublist{1},new);
				end
				tempM{end+1,1} = temp;
			end
			%
			tempM = tempM(2:end,1);
			rctns(end+1:end+m,1) = tempM;
			i = i + n + 1;
			continue;
		end
	end
end
rctns   = rctns(2:end,:);
% ----------------------------------------------------------------------------------
%	Read the reactants(rctnM) and products(prdtM) from the rctns
%	and put them in rcntM and prdtM.
% ----------------------------------------------------------------------------------
rcntM = { '', '' };
prdtM = { '', '' };
kM    = { '' };
dEgM   = [0];
for	j = 1:size(rctns,1)
	rctn = shortenStr(rctns{j});
	tempStr = regexp(rctn,'\s+!\s+','split');
	rctn = tempStr{1};
	k    = shortenStr(tempStr{2});
	k    = replace(k,'**','^');
	[ rcnt, prdt, dEg ] = readRcPr( rctn );

	% Put the rcnt(prdt) into the rcntM(prdtM).
	if size(rcnt,2) == size(rcntM,2)
		rcntM(end+1,:) = rcnt;
	elseif size(rcnt,2) < size(rcntM,2)
		rcntM(end+1,:) = [rcnt,repmat({''},1,size(rcntM,2)-size(rcnt,2))];
	else
		rcntM = [rcntM,repmat({''},size(rcntM,1),size(rcnt,2)-size(rcntM,2))];
		rcntM(end+1,:) = rcnt;
	end
	if size(prdt,2) == size(prdtM,2)
		prdtM(end+1,:) = prdt;
	elseif size(prdt,2) < size(prdtM,2)
		prdtM(end+1,:) = [prdt,repmat({''},1,size(prdtM,2)-size(prdt,2))];
	else
		prdtM = [prdtM,repmat({''},size(prdtM,1),size(prdt,2)-size(prdtM,2))];
		prdtM(end+1,:) = prdt;
	end
	%
	kM(end+1,1)   = {k};
	dEgM(end+1,1) = dEg;
end
rcntM = rcntM(2:end,:);
prdtM = prdtM(2:end,:);
kM    = kM(2:end,:);
dEgM  = dEgM(2:end,:);

spcs  = unique([rcntM,prdtM]);
spcs  = spcs(2:end,1);
end

