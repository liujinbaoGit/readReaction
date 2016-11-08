function outputStr = shortenStr( inputStr )
%% shortenStr [Version_16.11.03]
% ----------------------------------------------------------------------------------
% 	Read a char array, then output the one without ' ' ahead and tail.
% **********************************************************************************
if ~ischar(inputStr)
	error('The input is not a char array.');
else
	outputStr = regexp(inputStr,'\s*([^\s].*)','tokens');
	if isempty(outputStr)
		outputStr = '';
	else
		outputStr = outputStr{1}{:};
		outputStr = regexp(outputStr,'(.*[^\s])\s*','tokens');
		outputStr = outputStr{1}{:};
	end
end

