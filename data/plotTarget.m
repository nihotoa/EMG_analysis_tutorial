%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%coded by Naoki Uchida
% last modification : 2024.3.14(by Ohta)

[Your operation]
1. Please complete the steps up to pre-procedure (refer to below ([procedure]))
2. Go to the directory named 'data' (directory where this code exists)
3. Change some parameters (please refer to 'set param' section)
4. Please run this code & select data by following guidance (which is displayed in command window after Running this code)

[role of this code]
1. plot EMG (or activty pattern of muslcle Synergy) around each timing and save as figure 
2. Preapare data for cross-correlation analysis

[caution!!]
1. Sometimes the function 'uigetfile' is not executed and an error occurs
-> please reboot MATLAB


[procedure]
pre : MakeDataForPlot_H_utb.m or runnningEasyfunc.m

[改善点]
ドキュメンテーション関連
・日本語部分を無くす
・README.mdのフォーマットに従ってドキュメンテーションを書く

post解析関連
・pre初日のシナジーと,post初日のシナジーの入れ替えを自動で行う様に設定する(dispNMF_Wの方でも同様に)
・extract_post_daysって何?
・plot figure直前のpostデータの並び替えの2つのループはほぼ同じことをやっているので、関数にして、冗長じゃなくする
・(未確認)を修正する
・AllDaysNって何?
・evalを使っている部分を修正する => Post関連のところ以外は改善した
・monkeynameをなんとかして消したい

[リマインド]
・save_dataのセクションを消した。(チュートリアルで必要がないから)
・EMG_maxみたいなやつを消した(ローランドさんがやってくれたからやる必要ない)
・forHaraを消した(plot_figure_type, eliminate_musclesと,local関数のplot_timing_figures2を消した)
・save_xcorr_dataのセクションを消した(必要なさそうだったから)
・nmf_fold_nameを消した(最初から解析すれば一位に定まるから)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
realname = 'Yachimun'; % monkey name 'Yachimun'/'SesekiL'/'Wasa'
monkeyname = 'F'; % prefix of Raw data(ex) 'Se'/'Ya'/'F'/'Wa' 
plot_all = 1; % whether you want to plot figure focus on 'whole task'
plot_each_timing = 1; % whether you want to plot figure focus on 'each timing'
plot_type = 'EMG';  % the data which you want to plot -> 'EMG' or 'Synergy'
pColor = 'K';  % select 'K'(black plot) or 'C'(color plot) 【recommend!!】pre-analysis:'K' post-analysis:'C'
normalizeAmp = 0; % normalize Amplitude a
YL = Inf; % (if nomalize Amp == 0) ylim of graph
LineW = 1.5; %0.1;a % width of plot line 
synergy_order = [3,1,4,2];  % (pre1,2,3,4)に対応するpostのsynergy(Yachimun:[4,2,1,3], Seseki:[3,1,4,2])
timing_name_list = ["Lever1 on ", "Lever1 off ", "Lever2 on ", "Lever2 off"]; % this is used for titling
row_num = 4; % how many rows to display in one subplot figure
fig_type_array = {'stack', 'std'}; % you don't  need to change

%% code section

%% Get the plotWindow at each timing and list of the filenames of the files to be read.

% set the date list of data to be used as control data & the cutout range around each timing
switch realname
   case 'Yachimun'
      PreDays = [170516, 170517, 170524, 170526];
      % plot window (Xcorr data will be made in this range)
      plotWindow_cell{1} = [-25 5];
      plotWindow_cell{2} = [-15 15];
      plotWindow_cell{3} = [-15 15];
      plotWindow_cell{4} = [95 125];
    case 'SesekiL'
      PreDays = [200117, 200119, 200120];
      % plot window (Xcorr data will be made in this range)
      plotWindow_cell{1} = [-30 15];
      plotWindow_cell{2} = [-10 15];
      plotWindow_cell{3} = [-15 15];
      plotWindow_cell{4} = [98 115];
  case 'Wasa'
      PreDays = []; % to be decided
      % plot window (Xcorr data will be made in this range)
      plotWindow_cell{1} = [-25 5];
      plotWindow_cell{2} = [-15 15];
      plotWindow_cell{3} = [-15 15];
      plotWindow_cell{4} = [95 125];
end

% compile a list of names of files containing data to be plotted
[Allfiles_S, select_folder_path] = getFileName(plot_type, realname);
[~, session_num] = size(Allfiles_S);


% 未確認
Allfiles = strrep(Allfiles_S,'_Pdata.mat',''); % ok!!(フォルダ名に使うだけ)
AllDays = strrep(strrep(Allfiles, monkeyname, ''), '_', ''); % sgtitleに使うだけ(単純な日付が欲しい)
if pColor == 'C'
    AllDaysN = strrep(AllDays,'Syn4','');
    AllDaysN =str2double(AllDaysN');
end


%% Get the average data length over all sessions(days)

%get the session average of each parameter
for i = 1:session_num
    % load parameters
    load_file_path = fullfile(select_folder_path, Allfiles_S{i});
    load(load_file_path, "AllT", "TIME_W", "D" )
    
    if i == 1
        % Create empty array to store data from each timing
        timing_num = sum(startsWith(fieldnames(D), 'trig'));
        % for trial
        AllT_AVE = 0;
        Pall.Tlist = zeros(session_num, 1);
        
        % for each timing
        Ptrig = cell(timing_num-1, 1);
        for jj = 1:(timing_num-1)
            D_AVE.(['timing' num2str(jj)]) = 0;
            Ptrig{jj}.Tlist = zeros(session_num, 1);
        end
    end

    % store the data from each session
    % for trial
    AllT_AVE = (AllT_AVE*(i-1) + AllT)/i; 
    Pall.Tlist(i,1) = AllT;  
    
    % for each timing
    for jj = 1:(timing_num-1)
        original_data = D_AVE.(['timing' num2str(jj)]);
        added_data = D.(['Ld' num2str(jj)]);
        D_AVE.(['timing' num2str(jj)]) = (original_data * (i-1) + added_data)/i;
        Ptrig{jj}.Tlist(i,1) = added_data;
    end
end

%% Perform time normalization based on the session average of the acquired data lengths.

% Create empty structure to store data
% for trial
Pall.AllT_AVE = round(AllT_AVE);
Pall.plotData_sel = cell(session_num,1);

% for each timing
for ii = 1:(timing_num-1)
    Ptrig{ii}.AllT_AVE = round(D_AVE.(['timing' num2str(ii)]));
    Ptrig{ii}.plotData_sel = cell(session_num,1);
end

% store the data from each session
% for trial
for j = 1:session_num
    % load the data of the average activity pattern of each synergy (ormuscle) for this session
    load(fullfile(select_folder_path, Allfiles_S{j}), 'alignedDataAVE');

    if j == 1
        element_num = length(alignedDataAVE);
    end
    
    % Eliminate differences in length between sessions (perform time normalisation).
    plotData = AlignDatasets(alignedDataAVE, Pall.AllT_AVE); 

    if normalizeAmp == 1
        % divide by the maximum value of each element
        for mm = 1:element_num          
           plotData{mm} = plotData{mm} / max(plotData{mm});
        end
    end
    Pall.plotData_sel{j,1} = plotData;
end

% add data which is related to 'mean+std' to 'Pall' structure
[Pall] = makeSDdata(Pall, session_num, element_num);

% for each timing
for ii = 1:(timing_num-1)
    [Ptrig{ii}] = resampleEachTiming(Allfiles_S, Ptrig{ii}, ii, normalizeAmp, select_folder_path, element_num);

    % add data which is related to 'mean+std' to 'Ptrig{ii}' structure
    [Ptrig{ii}] = makeSDdata(Ptrig{ii}, session_num, element_num);
end

%% (未確認, postのデータをプロットする際に、preに順序を合わせるために、synergy_orderに従って入れ替える)
% if strcmp(plot_type, 'Synergy') && strcmp(pColor, 'C')
%     Pdata_list = {'Pall', 'Ptrig2', 'Ptrig3'};
%     days_num = length(AllDays);
%     for ii = 1:length(Pdata_list)
%         for d = 1:days_num
%             temp = eval([Pdata_list{ii} '.plotData_sel{d}(synergy_order, :);']);
%             eval([Pdata_list{ii} '.plotData_sel{d} = temp;'])
%         end
%     end
% end
% 
% % Rearrange post and concatenate it with pre
% if strcmp(plot_type, 'Synergy') && strcmp(pColor, 'K') && not(length(AllDays) == length(PreDays))
%     Pdata_list = {'Pall', 'Ptrig2', 'Ptrig3'};
%     for ii = 1:length(Pdata_list)
%         for d = length(PreDays)+1:length(AllDays)
%             temp = eval([Pdata_list{ii} '.plotData_sel{d}(synergy_order, :);']);
%             eval([Pdata_list{ii} '.plotData_sel{d} = temp;'])
%         end
%     end
% end

%% specify colormap for plot(P.PostDaysを未確認), ここじゃなくてよくねーか?
% if strcmp(pColor, 'C')
%     switch plot_type
%         case 'EMG'
%             [P.PostDays] = extract_post_days(PreDays);
%         case 'Synergy'
%             P.PostDays = AllDaysN;
%     end
% 
%     switch realname
%         case 'SesekiL'
%             color_id = 2;
%         otherwise
%             color_id = 1;
%     end
%     PostDays = P.PostDays;
%     Sp = length(PostDays);
%     Csp = zeros(Sp, 3);
%     Csp(:, color_id) = ones(Sp, 1).*linspace(0.3, 1, Sp)';
% end

%% define save folder path (which is stored all data & figures)
save_fold_path = fullfile(pwd, realname, 'easyData', 'P-DATA', [ Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',session_num)]);
makefold(save_fold_path);

%% plot figure

% comple the data needed to embelish the figure
% load taskRange
switch plot_type
    case 'EMG' 
        load(fullfile(select_folder_path, Allfiles_S{1}), 'taskRange', 'EMGs');
    case 'Synergy'
        % obtain a list of the percentage of cutouts to the entire task as 'TaskRange' (ex. [-50, 150])
        load(fullfile(select_folder_path, Allfiles_S{1}), 'taskRange');
end
Pall.x = linspace(taskRange(1), taskRange(2), Pall.AllT_AVE);

% add variables which is used in plot function in 'data_struct'
data_str = struct();
use_variable_name_list = {'element_num', 'session_num', 'pColor', 'LineW', 'normalizeAmp', 'YL', 'EMGs', 'plot_type', 'Csp', 'PostDays', 'AllDaysN', 'row_num', 'timing_num'};

% store data in a struct
not_exist_variables = {};
for jj = 1:length(use_variable_name_list)
    variable_name = use_variable_name_list{jj};
    try
        data_str.(variable_name) = eval(variable_name);
    catch
        not_exist_variables{end+1} = variable_name;
    end
end

% display not found variable in 'use_variable_name_list'
disp(['(' char(join(not_exist_variables, ', ')) ') is not found'])

%% 1. plot all taks range data(all muscle) -> plot range follows 'plotWindow'

if plot_all == 1
    % save_setting(determine file name for figure)
    save_figure_name =  ['All_' plot_type '(whole task)'];
    if normalizeAmp == 1
        save_figure_name = [save_figure_name '_normalized'];
    end
    
    % add plotWindow & Pdata to 'data_str'  
    data_str.Pdata = Pall;
    data_str.plotWindow = [-25 105];

    % create an array identifying 'fig_type'
    for idx = 1:length(fig_type_array)
        fig_type = fig_type_array{idx};

        % generate figure 
        f.fig1 = figure('position', [100, 100, 1000, 1000]);
    
        % plot figure
        f = plot_figures(f, data_str, 'whole_task', fig_type);
        sgtitle([fig_type ' ' plot_type ' in task(from' num2str(AllDays{1}) 'to' num2str(AllDays{end}) '-' num2str(length(AllDays)) ')'], 'FontSize', 25)
    
        % save figure
        saveas(gcf, fullfile(save_fold_path, [save_figure_name '_' fig_type '.fig']))
        saveas(gcf, fullfile(save_fold_path, [save_figure_name '_' fig_type '.png']))
        close all;
    end
end

%% plot EMG(or Synergy) which is aligned in each timing(timing1~timing4)

if plot_each_timing == 1
    % decide the number of created figures (4 muscles(or Synergies) per figure)
    figure_num = ceil(element_num/row_num); 
    
    % Create a struct array for figure to plot
    figure_str = struct;
    for idx = 1:length(fig_type_array)
        fig_type = fig_type_array{idx};
        figure_str.(fig_type) = struct;
        for ii = 1:figure_num
            figure_str.(fig_type).(['fig' num2str(ii)]) = figure("position", [100, 100, 1000, 1000]);
        end
    end

    for timing_id = 1:timing_num
        % load activity data and window info around timing to be focused
        timing_name = timing_name_list(timing_id);
        if or(timing_id==1, timing_id==timing_num)
            Pdata = Pall;
        else
            % add 'x' to 'Ptrig' struct
            Pdata = Ptrig{timing_id};
            Pdata.x =  linspace(-D.(['Range' num2str(timing_id)])(1), D.(['Range' num2str(timing_id)])(2), Pdata.AllT_AVE);
        end
        plotWindow = plotWindow_cell{timing_id}; % plotWindow at specified timing
        
        % add some variables (which is changed in loop) to 'data_str'
        data_str.timing_id = timing_id;
        data_str.timing_name = timing_name;
        data_str.plotWindow = plotWindow;
        data_str.Pdata = Pdata;

        % plot figures
        for idx = 1:length(fig_type_array)
            fig_type = fig_type_array{idx};
            figure_str.(fig_type) = plot_figures(figure_str.(fig_type), data_str, 'each_timing', fig_type);
        end
    end

    % save_figure
    switch pColor
        case 'K'
            added_info = 'monochro';
        case 'C'
            added_info = 'color';
    end

    for ii = 1:figure_num
        save_figure_name =  ['each_timing_figure' num2str(ii) '_' added_info];
        for idx = 1:length(fig_type_array)
            fig_type = fig_type_array{idx};
            figure(figure_str.(fig_type).(['fig' num2str(ii)]));
            saveas(gcf, fullfile(save_fold_path, [save_figure_name '_' fig_type '.fig']))
            saveas(gcf, fullfile(save_fold_path, [save_figure_name '_' fig_type '.png']))
        end
    end
    close all;
end
    
%% save data
if normalizeAmp == 1
    save(fullfile(save_fold_path, 'alignedEMG_data(normalizeAmp).mat'), 'Pall', 'Ptrig')
else
    save(fullfile(save_fold_path, 'alignedEMG_data.mat'), 'Pall', 'Ptrig')
end


%% define local function

% make PostDays
function [PostDays] = extract_post_days(PreDays)
    files_struct = dir('*_Pdata.mat');
    file_names = {files_struct.name};
    count = 1;
    for i = 1:numel(file_names)
        match = regexp(file_names{i}, '\d+', 'match'); %extract number part
        if ~ismember(str2double(match{1}), PreDays)
            PostDays(count) = str2double(match{1});
            count = count + 1;
        end
    end
end