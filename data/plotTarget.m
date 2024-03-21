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

その他
・evalを使っている部分を修正する => Post関連のところ以外は改善した
・可能な限り関数化する
    AlignDatasts, resampleEachTiming.mの部分
    plotTimingの部分
・monkeynameをなんとかして消したい
・plot_timing_figuresが冗長すぎるから改善したい & タスク全体と各タイミング付近とで似通った部分がかなりあるので関数化する
・(やらなくてもいいかも) 関数内で構造体を解凍する(datastr.sampleをsampleに代入するみたいな感じ)
・変数名の一部がインクリメントされているものを、cell配列に変更する
(ex.) data1.Tlist => data{1}.Tlist
・plot_timing_figuresのsubplotらへんが、timing_num == 4の場合にしか対応していないので、改善する
・AlignDatasetsとresampleEachTiming.mは共通点が多いので改善する
・plotTimingのコードが長すぎる
・AllDaysNって何?

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
plot_type = 'Synergy';  % the data which you want to plot -> 'EMG' or 'Synergy'
pColor = 'C';  % select 'K'(black plot) or 'C'(color plot) 【recommend!!】pre-analysis:'K' post-analysis:'C'
LineW = 1.5; %0.1; % width of plot line 
normalizeAmp = 1; % normalize Amplitude 
YL = Inf; % (if nomalize Amp == 0) ylim of graph
synergy_order = [3,1,4,2];  % (pre1,2,3,4)に対応するpostのsynergy(Yachimun:[4,2,1,3], Seseki:[3,1,4,2])

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

Allfiles = strrep(Allfiles_S,'_Pdata.mat',''); % ok!!(フォルダ名に使うだけ)
AllDays = strrep(strrep(Allfiles, monkeyname, ''), '_', ''); % sgtitleに使うだけ

% 未確認
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
        timing_num = sum(startsWith(fieldnames(D), 'trig'));
        % Create empty array to store data from entire trial
        AllT_AVE = 0;
        Pall.Tlist = zeros(session_num, 1);

        % Create empty array to store data from each timing
        Ptrig = cell(timing_num-1, 1);
        for jj = 1:(timing_num-1)
            D_AVE.(['timing' num2str(jj)]) = 0;
            Ptrig{jj}.Tlist = zeros(session_num, 1);
        end
    end

    % store the data from each session
    %AllT
    AllT_AVE = (AllT_AVE*(i-1) + AllT)/i; 
    Pall.Tlist(i,1) = AllT;  
    
    % each timing
    for jj = 1:(timing_num-1)
        original_data = D_AVE.(['timing' num2str(jj)]);
        added_data = D.(['Ld' num2str(jj)]);
        D_AVE.(['timing' num2str(jj)]) = (original_data * (i-1) + added_data)/i;
        Ptrig{jj}.Tlist(i,1) = added_data;
    end

end

%% Perform time normalisation based on the session average of the acquired data lengths.

% Create empty structure to store data(entire)
Pall.AllT_AVE = round(AllT_AVE);
Pall.plotData_sel = cell(session_num,1);

% Create empty structure to store data(each timing)
for ii = 1:(timing_num-1)
    Ptrig{ii}.AllT_AVE = round(D_AVE.(['timing' num2str(ii)]));
    Ptrig{ii}.plotData_sel = cell(session_num,1);
end


%%%  for trial  %%%
for j = 1:session_num
    % load the data of the average activity pattern of each synergy (ormuscle) for this session
    load(fullfile(select_folder_path, Allfiles_S{j}), 'alignedDataAVE');

    if j == 1
        element_num = length(alignedDataAVE); % synergy_num or EMG_num
    end
    
    % Eliminate differences in length between sessions (perform time normalisation).
    plotData = AlignDatasets(alignedDataAVE, Pall.AllT_AVE); 

    if normalizeAmp
        % divide by the maximum value of each element
        for mm = 1:element_num          
           plotData{mm} = plotData{mm} / max(plotData{mm});
        end
    end
    Pall.plotData_sel{j,1} = plotData;
end

%%%  for each timing  %%%
for ii = 1:(timing_num-1)
    [Ptrig{ii}] = resampleEachTiming(Allfiles_S, Ptrig{ii}, ii, normalizeAmp, select_folder_path, element_num);
end


%% make data for (mean + std) plot
[Pall] = makeSDdata(Pall, session_num, element_num);
for ii = 1:(timing_num-1)
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

%% define save folder path (which is stored all data & figures)
save_fold_path = fullfile(pwd, realname, 'easyData', 'P-DATA', [ Allfiles{1} 'to' Allfiles{end} '_' sprintf('%d',session_num)]);
makefold(save_fold_path);

%% plot figure

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

% make multiple figures (stack & (mean + std))
for m = 1:element_num
    % make stack figure
    figure(f_stack)
    switch plot_type
        case 'EMG'
            subplot(ceil(element_num / 4),4,m) %plot data in one figure   
        case 'Synergy'
            subplot(ceil(element_num / 2),2,m) %plot data in one figure   
    end
    hold on

    for d = 1:session_num
        switch pColor
            case 'K'
                try
                    plot(Pall.x,Pall.plotData_sel{d,1}{m,1}, 'k' ,'LineWidth',LineW);
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

    % decoration
    if normalizeAmp == 1
        ylim([0 1]);
    else
        ylim([0 YL]);
    end
    xlim([-25 105]); %narrow the range by following 'plotWindow'
    xline(0, 'color','b', 'LineWidth', LineW)
    xline(100, 'color', 'b', 'LineWidth', LineW)
    xlabel('task range[%]')

    if normalizeAmp == 0
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

        % paint the background of std
        sd = Pall.SD{m};
        y = Pall.AVE{m};
        xconf = [Pall.x Pall.x(end:-1:1)];
        yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
        hold on;
        fi = fill(xconf,yconf,'k');
        fi.FaceColor = [0.8 0.8 1];       % make the filled area pink
        fi.EdgeColor = 'none';            % remove the line around the filled area
        
        % plot average pattern
        plot(Pall.x,y,'k','LineWidth',LineW);

        % decoration
        xline(0,'color','b','LineWidth',LineW)
        xline(100,'color','b','LineWidth',LineW)
        xlim([-25 105]); %narrow the range by following 'plotWindow'
        xlabel('task range[%]')
        if normalizeAmp == 0
            ylabel('Amplitude[uV]')
        end

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

switch normalizeAmp
    case 0
        nomalize_str = '';
    case 1
        nomalize_str = '_normalized';
end
figure(f_stack)
sgtitle(['Stack ' plot_type ' in task(from' num2str(AllDays{1}) 'to' num2str(AllDays{end}) '-' num2str(length(AllDays)) ')'], 'FontSize', 25)    

% save figures(変数の中身が違うだけで、実行しているコードは同じだから、まとめる)
save_figure_name =  ['All_' plot_type '(whole task)' nomalize_str];
figure_type = '_stack';

saveas(gcf, fullfile(save_fold_path, [save_figure_name figure_type '.fig']))
saveas(gcf, fullfile(save_fold_path, [save_figure_name figure_type  '.png']))
if strcmp(pColor, 'K')
    figure(f_std)
    figure_type = '_std';

    saveas(gcf, fullfile(save_fold_path, [save_figure_name figure_type '.fig']))
    saveas(gcf, fullfile(save_fold_path, [save_figure_name figure_type '.png']))
end
close all;


%% plot EMG(or Synergy) which is aligned in each timing(timing1~timing4)
% decide the number of created figures (4 muscles(or Synergies) per figure)
figure_num = ceil(element_num/4); %plot 4 muscle's EMG   

% Create a struct array for figure to plot
figure_str = struct;
for ii = 1:figure_num
    figure_str.(['fig' num2str(ii)]) = figure("position", [100, 100, 1000, 1000]);
    if strcmp(pColor, 'K') % prepare for the figure of mean+-std
        figure_str.(['fig' num2str(ii) '_SD']) = figure("position", [100, 100, 1000, 1000]);
    end
end

% if Yachimun
timing_name_list = ["Lever1 on ", "Lever1 off ", "Lever2 on ", "Lever2 off"];

for timing_id = 1:timing_num
    timing_name = timing_name_list(timing_id);
    if or(timing_id==1, timing_id==timing_num)
        Pdata = Pall; % Data(EMG or Synergy) to be plotted
    else
        % add 'x' to 'Ptrig' struct
        Pdata = Ptrig{timing_id};
        Pdata.x =  linspace(-D.(['Range' num2str(timing_id)])(1), D.(['Range' num2str(timing_id)])(2), Pdata.AllT_AVE);
    end
    plotWindow = plotWindow_cell{timing_id}; % plotWindow at specified timing
    
    % collect data used for analysis into 'data_str' (struct array) 
    data_str = struct();
    use_variable_name_list = {'figure_str', 'timing_id', 'timing_name', 'element_num', 'session_num', 'pColor', 'Pdata', 'LineW', 'normalizeAmp', 'YL', 'plotWindow', 'EMGs', 'plot_type', 'Csp', 'PostDays', 'AllDaysN'};

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
    disp(['(' char(join(not_exist_variables, ', ')) ') is not found'])

    % plot figures
    plot_timing_figures(figure_str, data_str, timing_num)
end

% save figure
switch pColor
    case 'K'
        added_info = 'monochrome';
    case 'C'
        added_info = 'color';
end

for ii = 1:figure_num
    figure(figure_str.(['fig' num2str(ii)]));
    save_figure_name =  ['each_timing_stack_' num2str(ii) '_' added_info nomalize_str];

    saveas(gcf, fullfile(save_fold_path, [save_figure_name '.fig']))
    saveas(gcf, fullfile(save_fold_path, [save_figure_name '.png']))

    if strcmp(pColor, 'K') % prepare for the figure of mean+-std
        figure(figure_str.(['fig' num2str(ii) '_SD']));
        saveas(gcf, fullfile(save_fold_path, [save_figure_name '_std.fig']))
        saveas(gcf, fullfile(save_fold_path, [save_figure_name '_std.png']))
    end
end
close all;

% save data
if normalizeAmp
    save(fullfile(save_fold_path, 'alignedEMG_data(normalizeAmp).mat'), 'Pall', 'Ptrig')
else
    save(fullfile(save_fold_path, 'alignedEMG_data.mat'), 'Pall', 'Ptrig')
end


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
function plot_timing_figures(figure_str, data_str, timing_num)
    % (if timing_id == last_timing) change center persentage from 100 to 0
    if data_str.timing_id == timing_num
        data_str.Pdata.x = data_str.Pdata.x - 100;
        data_str.plotWindow = data_str.plotWindow - 100;
    end

    for m = 1:data_str.element_num%EMG_num(or Synergy_num) loop 
        plot_target = ceil(m/4); % figure number to plot
        figure(figure_str.(['fig' num2str(plot_target)]))
        % define subplot location
        k = m - 4*(plot_target-1) ;
        subplot_location = 4*(k-1) + data_str.timing_id; % if
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
        if data_str.normalizeAmp == 1
            ylim([0 1]);
        else
            ylim([0 data_str.YL]);
        end
        xlim(data_str.plotWindow);
        xlabel('task range[%]')
        if data_str.normalizeAmp == 0
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
            figure(figure_str.(['fig' num2str(plot_target) '_SD']))
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
            if data_str.normalizeAmp == 1
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