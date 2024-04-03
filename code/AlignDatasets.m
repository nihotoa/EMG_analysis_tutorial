%{
[explanation of this func]:
function to unify data length differences between sessions(dates) or trials by resampling.
This function is used in:
plotEasyData_utb.m
MakeDataForPlot_H_utb
plotTarget.m

[input arguments]
DATA: [cell array or double array], each cell contains activity data
tarLength: [double], Unified length. Perform resampling to this length

[output arguments]
alignedData: [cell array or double array], this is equal to 'DATA' resampled to 'tarLength'
%}

function [alignedDATA]=AlignDatasets(DATA, tarLength)
%{
explanation: change the construction of data & resample data(adjast to 'tarLength')
%}
if iscell(DATA)
    element_num = max(size(DATA));
    alignedDATA = cell(element_num,1);
    for ii = 1:element_num
        [alignedDATA{ii}] = AlignMatrixData(DATA{ii}, tarLength);
    end
else
   [alignedDATA] = AlignMatrixData(DATA, tarLength);
end

end

%% define local function
function [alignedDATA]=AlignMatrixData(DATA,tarLength)
% Transpose DATA matrix only 'row' direction data
DATA = DATA';
DATA_length = length(DATA);

% Time normalisation by comparing the length of the data in that session with the average of the length of the data in all sessions.
if length(DATA_length) == tarLength
   alignedDATA = DATA;
elseif length(DATA_length)<tarLength 
   alignedDATA = interpft(DATA,tarLength,1);
else
   alignedDATA = resample(DATA,tarLength,length(DATA_length));
end

% RE-Transpose alignedDATA matrix only 'row' direction data
alignedDATA = alignedDATA';
end