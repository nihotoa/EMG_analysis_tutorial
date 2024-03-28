%{
セッション(日付)ごとに1トライアルの平均の長さが違うので、resampleして(時間正規化して)セッション間の長さを統一するための関数
使われている関数:
plotEasyData_utb.m(runningEasyfuncの中で使われている)
MakeDataForPlot_H_utb
plotTarget.m
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