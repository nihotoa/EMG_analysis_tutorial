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
・cdで階層移動するのを止める
・日本語部分を無くす
・README.mdのフォーマットに従ってドキュメンテーションを書く
・plotに使ったEMGデータ(Pall, Ptrig1...)がどこに保存されるのかをinformationとして書く
・このデータは,normalizeされる場合とされない場合で区別されないで保存されている -> 名前で区別して保存する
・シナジーのHはeasyData -> Pdata -> フォルダ名の中に保存されることを書く
・pre初日のシナジーと,post初日のシナジーの入れ替えを自動で行う様に設定する(dispNMF_Wの方でも同様に)
・extract_post_daysって何?
・(未確認)を修正する
(ok!) SDのデータを作るところが冗長(Pall~Ptrig3まですべて同じ処理を行なっている)なので、関数を作る
・plot figure直前のpostデータの並び替えの2つのループはほぼ同じことをやっているので、関数にして、冗長じゃなくす
・exist()を使っている部分をすべて変更する

[リマインド]
・save_dataのセクションを消した。(チュートリアルで必要がないから)
・EMG_maxみたいなやつを消した(ローランドさんがやってくれたからやる必要ない)
・forHaraを消した(plot_figure_type, eliminate_musclesと,local関数のplot_timing_figures2を消した)
・save_xcorr_dataのセクションを消した(必要なさそうだったから)
・とりあえずplot_figure以前を改善していく
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
realname = 'Yachimun'; % monkey name 'Yachimun'/'SesekiL'/'Wasa'
monkeyname = 'F'; % prefix of Raw data(ex) 'Se'/'Ya'/'F'/'Wa' 
plot_type = 'EMG';  % the data which you want to plot -> 'EMG' or 'Synergy'
pColor = 'K';  % select 'K'(black plot) or 'C'(color plot) 【recommend!!】pre-analysis:'K' post-analysis:'C'
LineW = 1.5; %0.1; % width of plot line 
nomalizeAmp = 1; % normalize Amplitude 
YL = Inf; % (if nomalize Amp == 0) ylim of graph
nmf_fold_name = 'new_nmf_result';  % (if you want to plot synergy data) folder name of nmf_fold
synergy_order = [3,1,4,2];  % (pre1,2,3,4)に対応するpostのsynergy(Yachimun:[4,2,1,3], Seseki:[3,1,4,2])

%% code section

%% Get the plotWindow at each timing and list of the filenames of the files to be read.

% set the date list of data to be used as control data & the cutout range around each timing
switch realname
   case 'Yachimun'
      PreDays = [170516, 170517, 170524, 170526];
      % plot window (Xcorr data will be made in this range)
      plotWindow1 = [-25 5];
      plotWindow2 = [-15 15];
      plotWindow3 = [-15 15];
      plotWindow4 = [95 125];
    case 'SesekiL'
      PreDays = [200117, 200119, 200120];
      % plot window (Xcorr data will be made in this range)
      plotWindow1 = [-30 15];
      plotWindow2 = [-10 15];
      plotWindow3 = [-15 15];
      plotWindow4 = [98 115];
  case 'Wasa'
      PreDays = []; % to be decided
      % plot window (Xcorr data will be made in this range)
      plotWindow1 = [-25 5];
      plotWindow2 = [-15 15];
      plotWindow3 = [-15 15];
      plotWindow4 = [95 125];
end

% compile a list of names of files containing data to be plotted
disp("please select '_Pdata.mat' for all the dates you want to plot")
switch plot_type
    case 'EMG'
        select_folder_path = fullfile(pwd, realname, 'easyData', 'P-DATA');
    case 'Synergy'
        select_folder_path = fullfile(pwd, realname, nmf_fold_name, 'synData');
end

Allfiles_S = uigetfile(fullfile(select_folder_path ,'*_Pdata.mat'), 'Select One or More Files', 'MultiSelect', 'on');
if ischar(Allfiles_S)
    Allfiles_S = {Allfiles_S};
end
[~, session_num] = size(Allfiles_S);

Allfiles = strrep(Allfiles_S,'_Pdata.mat',''); 
AllDays = strrep(strrep(Allfiles, monkeyname, ''), '_', '');

% 未確認
if pColor == 'C'
    AllDaysN = strrep(AllDays,'Syn4','');
    AllDaysN =str2double(AllDaysN');
end


%% Get the average data length over all sessions(days)

% Prepare empty arrays
AllT_AVE = 0;
D1_AVE = 0;
D2_AVE = 0;
D3_AVE = 0;

Pall.Tlist = zeros(session_num, 1);
Ptrig1.Tlist = zeros(session_num, 1);
Ptrig2.Tlist = zeros(session_num, 1);
Ptrig3.Tlist = zeros(session_num, 1);

%get the session average of each parameter
for i = 1:session_num
    % load parameters
    load_file_path = fullfile(select_folder_path, Allfiles_S{i});
    load(load_file_path, "AllT", "TIME_W", "D" )

    %AllT
    AllT_AVE = (AllT_AVE*(i-1) + AllT)/i;
    Pall.Tlist(i,1) = AllT;

    %D.Ld1
    D1_AVE = (D1_AVE*(i-1) + D.Ld1)/i;
    Ptrig1.Tlist(i,1) = D.Ld1;

    %D.Ld2
    D2_AVE = (D2_AVE*(i-1) + D.Ld2)/i;
    Ptrig2.Tlist(i,1) = D.Ld2;

    %D.Ld3
    D3_AVE = (D3_AVE*(i-1) + D.Ld3)/i;
    Ptrig3.Tlist(i,1) = D.Ld3;

end

%% Perform time normalisation based on the session average of the acquired data lengths.

% Create empty structure to store data
Pall.AllT_AVE = round(AllT_AVE);
Ptrig1.AllT_AVE = round(D1_AVE);
Ptrig2.AllT_AVE = round(D2_AVE);
Ptrig3.AllT_AVE = round(D3_AVE);

Pall.plotData_sel = cell(session_num,1);
Ptrig1.plotData_sel = cell(session_num,1);
Ptrig2.plotData_sel = cell(session_num,1);
Ptrig3.plotData_sel = cell(session_num,1);

%%%  for trial  %%%
for j = 1:session_num
    % load the data of the average activity pattern of each synergy (ormuscle) for this session
    load(fullfile(select_folder_path, Allfiles_S{j}), 'alignedDataAVE');
    element_num = length(alignedDataAVE); % synergy_num or EMG_num
    
    % Eliminate differences in length between sessions (perform time normalisation).
    plotData = AlignDatasets(alignedDataAVE, Pall.AllT_AVE); 

    if nomalizeAmp
        % divide by the maximum value of each element
        for mm = 1:element_num          
           plotData{mm} = plotData{mm} / max(plotData{mm});
        end
    end
    Pall.plotData_sel{j,1} = plotData;
end

%%%  for each timing  %%%
[Ptrig1] = resampleEachTiming(Allfiles_S, Ptrig1, 1, nomalizeAmp, select_folder_path, element_num);
[Ptrig2] = resampleEachTiming(Allfiles_S, Ptrig2, 2, nomalizeAmp, select_folder_path, element_num);
[Ptrig3] = resampleEachTiming(Allfiles_S, Ptrig3, 3, nomalizeAmp, select_folder_path, element_num);


%% make data for (mean + std) plot
[Pall] = makeSDdata(Pall, session_num, element_num);
[Ptrig1] = makeSDdata(Ptrig1, session_num, element_num);
[Ptrig2] = makeSDdata(Ptrig2, session_num, element_num);
[Ptrig3] = makeSDdata(Ptrig3, session_num, element_num);

%% (未確認, postのデータをプロットする際に、preに順序を合わせるために、synergy_orderに従って入れ替える)
if strcmp(plot_type, 'Synergy') && strcmp(pColor, 'C')
    Pdata_list = {'Pall', 'Ptrig2', 'Ptrig3'};
    days_num = length(AllDays);
    for ii = 1:length(Pdata_list)
        for d = 1:days_num
            temp = eval([Pdata_list{ii} '.plotData_sel{d}(synergy_order, :);']);
            eval([Pdata_list{ii} '.plotData_sel{d} = temp;'])
        end
    end
end

% Rearrange post and concatenate it with pre
if strcmp(plot_type, 'Synergy') && strcmp(pColor, 'K') && not(length(AllDays) == length(PreDays))
    Pdata_list = {'Pall', 'Ptrig2', 'Ptrig3'};
    for ii = 1:length(Pdata_list)
        for d = length(PreDays)+1:length(AllDays)
            temp = eval([Pdata_list{ii} '.plotData_sel{d}(synergy_order, :);']);
            eval([Pdata_list{ii} '.plotData_sel{d} = temp;'])
        end
    end
end

%% specify colormap for plot(P.PostDaysを未確認), ここじゃなくてよくねーか?
if strcmp(pColor, 'C')
    switch plot_type
        case 'EMG'
            [P.PostDays] = extract_post_days(PreDays);
        case 'Synergy'
            P.PostDays = AllDaysN;
    end

    switch realname
        case 'SesekiL'
            color_id = 2;
        otherwise
            color_id = 1;
    end
    PostDays = P.PostDays;
    Sp = length(PostDays);
    Csp = zeros(Sp, 3);
    Csp(:, color_id) = ones(Sp, 1).*linspace(0.3, 1, Sp)';
end

% define save folder path (which is stored all data & figures)
save_fold_path = fullfile(pwd, realname, 'easyData', 'P-DATA', [ Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',session_num)]);
makefold(save_fold_path);

%% plot figure
disp('start %%%%%%%%%%%%%%%% PLOT DATA %%%%%%%%%%%%%%%%')
%% 1. plot all taks range data(all muscle) -> plot range follows 'plotWindow'

switch plot_type
    case 'EMG' 
        load(fullfile(select_folder_path, Allfiles_S{1}), 'taskRange', 'EMGs');
    case 'Synergy'
        % obtain a list of the percentage of cutouts to the entire task as 'TaskRange' (ex. [-50, 150])
        load(fullfile(select_folder_path, Allfiles_S{1}), 'taskRange');
end
Pall.x = linspace(taskRange(1), taskRange(2), Pall.AllT_AVE);

% generate figure 
f_stack = figure('position', [100, 100, 1000, 1000]);
if strcmp(pColor, 'K')
    f_std = figure('position', [100, 100, 1000, 1000]);
end

% make 2 figures (stack & (mean + std))
for m = 1:element_num
    % make stack figure
    figure(f_stack)
    switch plot_type
        case 'EMG'
            subplot(ceil(element_num/4),4,m) %plot data in one figure   
        case 'Synergy'
            subplot(ceil(element_num/2),2,m) %plot data in one figure   
    end
    hold on

    for d = 1:session_num%file=num loop
        switch pColor
            case 'K'
                try
                    plot(Pall.x,Pall.plotData_sel{d,1}{m,1},'k','LineWidth',LineW);
                    max_value = max(Pall.plotData_sel{d,1}{m,1});
                catch
                    plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'k','LineWidth',LineW);
                    max_value = max(Pall.plotData_sel{d,1}(m,:));
                end
            case 'C'
                try
                    plot(Pall.x,Pall.plotData_sel{d,1}{m,1},'Color',Csp(d,:),'LineWidth',LineW);
                    max_value = max(Pall.plotData_sel{d,1}{m,1});
                catch
                    plot(Pall.x,Pall.plotData_sel{d,1}(m,:),'Color',Csp(d,:),'LineWidth',LineW);
                    max_value = max(Pall.plotData_sel{d,1}(m,:));
                end
        end
    end

    if nomalizeAmp == 1
        ylim([0 1]);
    else
        ylim([0 YL]);
    end

    % decoration
    xlim([-25 105]); %narrow the range by following 'plotWindow'
    xline(0,'color','b','LineWidth',LineW)
    xline(100,'color','b','LineWidth',LineW)
    xlabel('task range[%]')

    if nomalizeAmp == 0
        ylabel('Amplitude[uV]')
    end

    switch plot_type
        case 'EMG'
            title(EMGs{m}, 'FontSize', 20)
        case 'Synergy'
            title(['Synergy' num2str(m)], 'FontSize', 20)
    end
   
    % make (mean+std) figure
    if pColor=='K'
        figure(f_std)
        switch plot_type
            case 'EMG'
                subplot(ceil(element_num/4),4,m) %plot data in one figure
            case 'Synergy'
                subplot(ceil(element_num/2),2,m) %plot data in one figure
        end
        sd = Pall.SD{m};
        y = Pall.AVE{m};
        xconf = [Pall.x Pall.x(end:-1:1)];
        yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
        hold on;
        fi = fill(xconf,yconf,'k');
        fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
        fi.EdgeColor = 'none';            % remove the line around the filled area
        plot(Pall.x,y,'k','LineWidth',LineW);
        xline(0,'color','b','LineWidth',LineW)
        xline(100,'color','b','LineWidth',LineW)
        xlim([-25 105]); %narrow the range by following 'plotWindow'
        xlabel('task range[%]')
        if nomalizeAmp == 0
            ylabel('Amplitude[uV]')
        end
        % title
        switch plot_type
            case 'EMG'
                title(EMGs{m}, 'FontSize', 20)
            case 'Synergy'
                title(['Synergy' num2str(m)], 'FontSize', 20)
        end
        hold off;
        sgtitle(['Average ' plot_type ' in task(from' num2str(AllDays{1}) 'to' num2str(AllDays{end}) '-' num2str(length(AllDays)) ')'], 'FontSize', 25)
    end
end

switch nomalizeAmp
    case 0
        nomalize_str = '';
    case 1
        nomalize_str = '_nomalirzed';
end
figure(f_stack)
sgtitle(['Stack ' plot_type ' in task(from' num2str(AllDays{1}) 'to' num2str(AllDays{end}) '-' num2str(length(AllDays)) ')'], 'FontSize', 25)    

% save figures
saveas(gcf, fullfile(save_fold_path, ['All_' plot_type '(whole task)_stack' nomalize_str '.fig']))
saveas(gcf, fullfile(save_fold_path, ['All_' plot_type '(whole task)_stack' nomalize_str '.png']))
if strcmp(pColor, 'K')
    figure(f_std)
    saveas(gcf, fullfile(save_fold_path, ['All_' plot_type '(whole task)_std.fig']))
    saveas(gcf, fullfile(save_fold_path, ['All_' plot_type '(whole task)_std.png']))
end
close all;


%% plot EMG(or Synergy) which is aligned in each timing(timing1~timing4)
% decide the number of created figures (4 muscles(or Synergies) per figure)
figure_num = ceil(element_num/4); %plot 4 muscle's EMG   

% Create a struct array for figure to plot
figure_str = struct;
for ii = 1:figure_num
    eval(['figure_str.fig' num2str(ii) ' = figure("position", [100, 100, 1000, 1000])'])
    if strcmp(pColor, 'K') % prepare for the figure of mean+-std
        eval(['figure_str.fig' num2str(ii) '_SD = figure("position", [100, 100, 1000, 1000])'])
    end
end

% if Yachimun
timing_name_list = ["Lever1 on ", "Lever1 off ", "Lever2 on ", "Lever2 off"];

for timing_num = 1:4 
    timing_name = timing_name_list(timing_num);
    if or(timing_num==1, timing_num==4)
        Pdata = Pall; % Data(EMG or Synergy) to be plotted
    else
        % add 'x' to 'Ptrig' struct
        eval(['Ptrig' num2str(timing_num) '.x = linspace(-D.Range1(1), D.Range1(2), Ptrig' num2str(timing_num) '.AllT_AVE);'])
        Pdata = eval(['Ptrig' num2str(timing_num)]);
    end
    plotWindow = eval(['plotWindow' num2str(timing_num)]); % plotWindow at specified timing
    
    % collect data used for analysis into 'data_str' (struct array) 
    data_str = struct;
    variable_list = who;
    switch pColor
        case 'C'
            use_variable_list = {'figure_str', 'timing_num', 'timing_name', 'element_num', 'session_num', 'pColor', 'Pdata', 'LineW', 'nomalizeAmp', 'YL','plotWindow', 'EMGs', 'plot_type', 'Csp', 'PostDays', 'AllDaysN'};
            for jj = 1:length(variable_list)
                if any(strcmp(use_variable_list, variable_list{jj}))
                    eval(['data_str.' variable_list{jj} ' = eval("' variable_list{jj} '");'])
                end
            end
            plot_timing_figures(figure_str, data_str)
        case 'K'
            use_variable_list = {'figure_str', 'timing_num', 'timing_name', 'element_num', 'session_num', 'pColor', 'Pdata', 'LineW', 'nomalizeAmp', 'YL','plotWindow', 'EMGs', 'plot_type'};
            for jj = 1:length(variable_list)
                if any(strcmp(use_variable_list, variable_list{jj}))
                    eval(['data_str.' variable_list{jj} ' = eval("' variable_list{jj} '");'])
                end
            end
            plot_timing_figures(figure_str, data_str)
    end
end

% save figure
switch pColor
    case 'K'
        added_info = 'monochrome';
    case 'C'
        added_info = 'color';
end

for ii = 1:figure_num
    eval(['figure(figure_str.fig' num2str(ii) ')'])
    saveas(gcf, fullfile(save_fold_path, ['each_timing_stack_' num2str(ii) '_' added_info nomalize_str '.fig']))
    saveas(gcf, fullfile(save_fold_path, ['each_timing_stack_' num2str(ii) '_' added_info nomalize_str '.png']))
    if strcmp(pColor, 'K') % prepare for the figure of mean+-std
        eval(['figure(figure_str.fig' num2str(ii) '_SD)'])
        saveas(gcf, fullfile(save_fold_path, ['each_timing_stack_' num2str(ii) '_' added_info nomalize_str '_std.fig']))
        saveas(gcf, fullfile(save_fold_path, ['each_timing_stack_' num2str(ii) '_' added_info nomalize_str '_std.png']))
    end
end
close all;
% save data
save(fullfile(save_fold_path, 'alignedEMG_data.mat'), 'Pall', 'Ptrig2', 'Ptrig3')

%% define local function

%% make PostDays
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

%% plot each timing figures
function plot_timing_figures(figure_str, data_str)
    % change center persentage from 100 to 0
    if data_str.timing_num == 4
        data_str.Pdata.x = data_str.Pdata.x-100;
        data_str.plotWindow = data_str.plotWindow-100;
    end
    
    for m = 1:data_str.element_num%EMG_num(or Synergy_num) loop 
        plot_target = ceil(m/4); % figure number to plot
        eval(['figure(figure_str.fig' num2str(plot_target) ')'])
        % define subplot location
        k = m - 4*(plot_target-1) ;
        subplot_location = 4*(k-1) + data_str.timing_num; % if
        subplot(4, 4, subplot_location);
        hold on
        for d = 1:data_str.session_num%file=num loop
            switch data_str.pColor
                case 'C'
                    try
                        plot(data_str.Pdata.x,cell2mat(data_str.Pdata.plotData_sel{d,1}(m,:)),'Color',data_str.Csp(d,:),'LineWidth',data_str.LineW);
                    catch
                        plot(data_str.Pdata.x,data_str.Pdata.plotData_sel{d,1}(m,:),'Color',data_str.Csp(d,:), 'LineWidth',data_str.LineW);
                    end
                case 'K'
                    try
                        plot(data_str.Pdata.x,cell2mat(data_str.Pdata.plotData_sel{d,1}(m,:)),'k','LineWidth',data_str.LineW);
                    catch
                        plot(data_str.Pdata.x,data_str.Pdata.plotData_sel{d,1}(m,:),'k','LineWidth',data_str.LineW);
                    end
            end
        end
        % decoration
        xline(0,'color','r','LineWidth',data_str.LineW)
        hold off
        if data_str.nomalizeAmp == 1
            ylim([0 1]);
        else
            ylim([0 data_str.YL]);
        end
        xlim(data_str.plotWindow);
        xlabel('task range[%]')
        if data_str.nomalizeAmp == 0
            ylabel('Amplitude[uV]')
        end
        switch data_str.plot_type
            case 'EMG'
                title([data_str.timing_name data_str.EMGs{m}])
            case 'Synergy'
                title([data_str.timing_name 'Synergy' num2str(m)])
        end

        % plot mean+-std
        if data_str.pColor=='K'
            % focus on FigTrigSD
            eval(['figure(figure_str.fig' num2str(plot_target) '_SD)']) %switch the focued figure
            sd = data_str.Pdata.SD{m};
            y = data_str.Pdata.AVE{m};
            xconf = [data_str.Pdata.x data_str.Pdata.x(end:-1:1)];
            yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
            subplot(4, 4, subplot_location);
            hold on;
            fi = fill(xconf,yconf,'k');
            fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
            fi.EdgeColor = 'none';            % remove the line around the filled area
            plot(data_str.Pdata.x,y,'k','LineWidth',data_str.LineW);
            % decoration
            xline(0,'color','r','LineWidth',data_str.LineW)
            xlabel('task range[%]')
            hold off;
            if data_str.nomalizeAmp == 1
                ylim([0 1]);
            else
                ylim([0 data_str.YL]);
                ylabel('Amplitude[uV]')
            end
            xlim(data_str.plotWindow);
            % title
            switch data_str.plot_type
                case 'EMG'
                    title([data_str.timing_name data_str.EMGs{m}])
                case 'Synergy'
                    title([data_str.timing_name 'Synergy' num2str(m)])
            end
        end
    end
end