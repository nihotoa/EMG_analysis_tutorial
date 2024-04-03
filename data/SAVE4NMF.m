%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
[your operation]
1. Go to the directory named 'data' (directory where this code exists)
2. Change some parameters (please refer to 'set param' section)
3. Please run this code

[role of this code]
concatenate & create one-day EMG data (with resampling(5000Hz)) & save individual muscle data as '(uv).mat' 

[Saved data location]
location: Yachimun/new_nmf_result/'~_standard' (ex.) F170516_standard
file name: muscle_name(uV).mat (ex.) PL(uV).mat

[procedure]
pre:SaveFileInfo
post:filterBat_SynNMFPre.m

[Improvement points(Japanaese)]
・ファイルを連結する時に, 連番じゃ無いものは対応していないことを念頭に置いておく
(例)file 002, file004が使用するファイルだった時にはエラー吐く(002, 003, 004をloadしようとするから)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
real_name = 'Yachimun'; % Name of the directory containing the data you want to analyze
task = 'standard'; % you don't need to change this parameter

% parameters used in local function(MakeData4nmf)
param_struct = struct();
param_struct.save_fold = 'new_nmf_result'; % not need to change
param_struct.downsample = 1; % whether you want to perform down sampling(1 or 0)
param_struct.downdata_to =5000; % Sampling frequency after down sapling
param_struct.save_EMG = 1; % whether you want to save EMG data(1 or 0)

%% code section
% get prefix of file name
files_list = dir(fullfile(pwd, real_name));
mat_file_list = files_list(endsWith({files_list.name}, '.mat'));
number_parts = regexp(mat_file_list(1).name, '\d+', 'match');
string_parts = split(mat_file_list(1).name, number_parts{1});
prefix = string_parts{1};

%  get the file name list of  '~standard.mat'
standard_fold_path = fullfile(pwd, real_name, 'easyData');
disp('Please select all "F~_standard.mat"');
standard_file_list = uigetfile(standard_fold_path, 'Select One or More Files', 'MultiSelect', 'on');

% count the number of sessions
if iscell(standard_file_list)
   [~, session_num] = size(standard_file_list);
   elseif ischar(standard_file_list)
      session_num = 1;
      standard_file_list = cellstr(standard_file_list);
end

% combine multiple data for one day into a single data
easy_data_fold_path = fullfile(pwd, real_name, 'easyData');
for s = 1:session_num
   load(fullfile(easy_data_fold_path, standard_file_list{s}), 'fileInfo'); 
   % concatenate experiment data and save each EMG as individual file
   MakeData4nmf(fileInfo.monkeyname, real_name, sprintf('%d',fileInfo.xpdate), fileInfo.file_num, task, param_struct)
   disp(['finish making data file for nmf : ' real_name '-' strrep(standard_file_list{s}, '_standard.mat', '')])
end

%% define local function

% [role of this function] concatenate experiment data and save each EMG as individual file
function [] = MakeData4nmf(monkeyname, real_name, xpdate, file_num, task, param_struct)

% Store the name of the muscle corresponding to each electrode in the cell array
switch monkeyname
    case 'Wa'%Wasa
        % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(14,1) ;
        EMGs{1,1}= 'Delt';
        EMGs{2,1}= 'Biceps';
        EMGs{3,1}= 'Triceps';
        EMGs{4,1}= 'BRD';
        EMGs{5,1}= 'cuff';
        EMGs{6,1}= 'ED23';
        EMGs{7,1}= 'ED45';
        EMGs{8,1}= 'ECR';
        EMGs{9,1}= 'ECU';
        EMGs{10,1}= 'EDC';
        EMGs{11,1}= 'FDS';
        EMGs{12,1}= 'FDP';
        EMGs{13,1}= 'FCU';
        EMGs{14,1}= 'FCR';
    case 'Ya'%Yachimun
        % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,1) ;
        EMGs{1,1}= 'FDP';
        EMGs{2,1}= 'FDSprox';
        EMGs{3,1}= 'FDSdist';
        EMGs{4,1}= 'FCU';
        EMGs{5,1}= 'PL';
        EMGs{6,1}= 'FCR';
        EMGs{7,1}= 'BRD';
        EMGs{8,1}= 'ECR';
        EMGs{9,1}= 'EDCprox';
        EMGs{10,1}= 'EDCdist';
        EMGs{11,1}= 'ED23';
        EMGs{12,1}= 'ECU';
    case 'F' %Yachimun
        % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,1) ;
        EMGs{1,1}= 'FDP';
        EMGs{2,1}= 'FDSprox';
        EMGs{3,1}= 'FDSdist';
        EMGs{4,1}= 'FCU';
        EMGs{5,1}= 'PL';
        EMGs{6,1}= 'FCR';
        EMGs{7,1}= 'BRD';
        EMGs{8,1}= 'ECR';
        EMGs{9,1}= 'EDCprox';
        EMGs{10,1}= 'EDCdist';
        EMGs{11,1}= 'ED23';
        EMGs{12,1}= 'ECU';
    case 'Su'%Suruku
        % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12,1) ;
        EMGs{1,1}= 'FDS';
        EMGs{2,1}= 'FDP';
        EMGs{3,1}= 'FCR';
        EMGs{4,1}= 'FCU';
        EMGs{5,1}= 'PL';
        EMGs{6,1}= 'BRD';
        EMGs{7,1}= 'EDC';
        EMGs{8,1}= 'ED23';
        EMGs{9,1}= 'ED45';
        EMGs{10,1}= 'ECU';
        EMGs{11,1}= 'ECR';
        EMGs{12,1}= 'Deltoid';
   case 'Se'%Seseki
        % which EMG channels will be imported and/or filtered (channels are numbered according to the output file, not the AO original channel ID)
        EMGs=cell(12, 1) ;
        EMGs{1,1}= 'EDC';
        EMGs{2,1}= 'ED23';
        EMGs{3,1}= 'ED45';
        EMGs{4,1}= 'ECU';
        EMGs{5,1}= 'ECR';
        EMGs{6,1}= 'Deltoid';
        EMGs{7,1}= 'FDS';
        EMGs{8,1}= 'FDP';
        EMGs{9,1}= 'FCR';
        EMGs{10,1}= 'FCU';
        EMGs{11,1}= 'PL';
        EMGs{12,1}= 'BRD';
    case 'Ma'
        Mn = 8;
        EMGs=cell(Mn,1) ;
        EMGs{1,1}= 'EDC';
        EMGs{2,1}= 'ECR';
        EMGs{3,1}= 'BRD_1';
        EMGs{4,1}= 'FCU';
        EMGs{5,1}= 'FCR';
        EMGs{6,1}= 'BRD_2';
        if Mn == 8
           EMGs{7,1}= 'FDPr';
           EMGs{8,1}= 'FDPu';
        end
end
EMG_num = length(EMGs);

% set param
save_fold = param_struct.save_fold;
downsample = param_struct.downsample;
downdata_to =param_struct.downdata_to;
save_EMG = param_struct.save_EMG ;

% concanenate EMG data
[AllData_EMG, TimeRange, EMG_Hz] = makeEasyEMG(monkeyname, xpdate, file_num, real_name);

% Down sample these EMG data (from 'EMG_Hz'[Hz] to 'down_data_to'[Hz])
if downsample==1
    AllData_EMG = resample(AllData_EMG, downdata_to, EMG_Hz);
end

% save EMG data as .mat file for nmf
if save_EMG == 1
    common_save_fold_path = fullfile(pwd, real_name, save_fold);
    save_fold_path = fullfile(common_save_fold_path, [monkeyname xpdate '_' task]);
    makefold(save_fold_path)
    % save each muscle EMG data to a file
    for i = 1:EMG_num
        Name = cell2mat(EMGs(i,1));
        Class = 'continuous channel';
        SampleRate = downdata_to;
        Data = AllData_EMG(:, i)';
        Unit = 'uV';
        save(fullfile(save_fold_path, [cell2mat(EMGs(i,1)) '(uV).mat']), 'TimeRange', 'Name', 'Class', 'SampleRate', 'Data', 'Unit');
    end
end
end

