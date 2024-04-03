%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{

[your operation]
1. Go to the directory named 'new_nmf_result(directory where this file exists)''
2. Please change parameters

[role of this code]
ÅEOutput a single figure of the spatial pattern of each synergy for all dates selected by the UI operation.
ÅEStore data on the mapping of each synergy on each date and on the spatial pattern of synergies (synergy W) summarised.

[Saved data location]
    As for figure:
        Yachimun/new_nmf_result/syn_figures/F170516to170526_4/      (if you selected 'pre' for 'term_type')

    As for synergy order data:
        Yachimun/new_nmf_result/order_tim_list/F170516to170526_4/     (if you selected 'pre' for 'term_type')

    As for synergy W data (for anova):
        Yachimun/new_nmf_result/W_synergy_data/

    As for synergy W data:
        Yachimun/new_nmf_result/spatial_synergy_data/dist-dist/

[procedure]
pre: SYNERGYPLOT.m
post: MakeDataForPlot_H_utb.m

[Improvement points(Japanaese)]
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;

%% set param
monkeyname = 'F';  % Name prefix of the folder containing the synergy data for each date
term_type = 'post';  % Which period synergies do you want to plot?
syn_num = 4; % number of synergy you want to analyze
save_WDaySynergy = 1;% Whether to save synergy W (to be used for ANOVA)
save_data = 1; % Whether to store data on synergy orders in 'order_tim_list' folder (should basically be set to 1).
save_fig = 1; % Whether to save the plotted synergy W figure
synergy_combination = 'dist-dist'; % dist-dist/prox-dist/all etc..

%% code section

% do not change(Pre dates in Yachimun's experiments)
pre_days = [...
                 170516; ...
                 170517; ...
                 170524; ...
                 170526; ...
                 ];

% Create a list of folders containing the synergy data for each date.
data_folders = dir(pwd);
folderList = {data_folders([data_folders.isdir]).name};
Allfiles_S = folderList(startsWith(folderList, monkeyname));

% (you don't need to change)Further refinement by term_type
switch term_type
    case 'pre'
        Allfiles_S = Allfiles_S(1:4);
    case 'post'
        Allfiles_S = Allfiles_S(5:end);
end

S = size(Allfiles_S);
Allfiles = strrep(Allfiles_S, '_standard','');
days = strrep(Allfiles, monkeyname, '');
days = cellfun(@str2double, days);
days = transpose(days);
day_num = length(days);

% determine 'term_group'
if any(ismember(days, pre_days))
    term_group = 'pre';
else
    term_group = 'post';
end

%% Get the name of the EMG used for the synergy analysis
first_date_fold_name = Allfiles_S{1};

% Get the path of the file that has name information of EMG used for muscle synergy analysis
first_date_file_path = fullfile(pwd, first_date_fold_name, [first_date_fold_name '.mat']);

% get name information of EMG used for muscle synergy analysis
load(first_date_file_path, 'TargetName');
EMGs = get_EMG_name(TargetName);
EMG_num = length(EMGs);


%% Reorder the synergies to match the synergies on the first day.

% align the order of synergies
[Wt, k_arr] = OrderSynergy(EMG_num, syn_num, monkeyname, days);

if strcmp(term_group, 'post')
    % align the order of synergies with the 1st day of 'pre'
    compair_days = [pre_days(1); days(1)];
    [~, order_list] = OrderSynergy(EMG_num, syn_num, monkeyname, compair_days);
    synergy_order = order_list(:, 2);

    % align with using 'synergy_order'
    k_arr = k_arr(synergy_order, :);
    Wt = cellfun(@(x) x(:, synergy_order), Wt, 'UniformOutput', false);
end

% Expand Wt & rearrange columns
Walt = cell2mat(Wt);
Wall = Walt;
for s_id = 1:syn_num
    for d_id=1:day_num
        Wall(:,(s_id-1)*day_num+d_id) = Walt(:,(d_id-1)*syn_num+s_id);
    end
end

%% plot figure(Synergy_W)

% Organize the information needed for plot.
x = categorical(EMGs');
muscle_name = x; 
zeroBar = zeros(EMG_num,1);

% make folder to save figures
save_figure_folder_path = fullfile(pwd, 'syn_figures', [monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',day_num)]);
makefold(save_figure_folder_path);

for s_id=1:syn_num 
    f1 = figure('Position',[300,250*s_id,750,400]);
    hold on;
    
    % create plotted_W
    plotted_W = nan(EMG_num, day_num);
    for d_id = 1:day_num
        plotted_W(:, d_id) = Wt{d_id}(:, s_id);
    end
    bar(x,[zeroBar plotted_W],'b','EdgeColor','none');

    % decoration
    ylim([0 2.5]);
    a = gca;
    a.FontSize = 20;
    a.FontWeight = 'bold';
    a.FontName = 'Arial';
    if save_fig == 1
        figure1_name = ['W' sprintf('%d',syn_num) '_' mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',day_num) '_syn' sprintf('%d',s_id)];
        saveas(f1, fullfile(save_figure_folder_path, [figure1_name '.fig']));
        saveas(f1, fullfile(save_figure_folder_path, [figure1_name '.png']));
    end
end
close all;

% make directory to save synergy_W data & save data.
if save_WDaySynergy == 1
    makefold('W_synergy_data');

    % Changing the structure of an array
    WDaySynergy = cell(1,syn_num);
    for s_id = 1:syn_num
        for d_id = 1:day_num
            WDaySynergy{s_id}(:, d_id) = Wt{d_id}(:, s_id);
        end
    end
    
    % save_data
    data_file_name = [monkeyname num2str(days(1)) 'to' num2str(days(end)) '_' num2str(day_num) '(' term_group ')'];
    save(fullfile(pwd, 'W_synergy_data', data_file_name), 'WDaySynergy', 'x');
end

%% Plot the average value of synergy_W for all selected dates
aveWt = Wt{1};
% calcrate the average of synergy W
for d_id=1:day_num
    aveWt = (aveWt.*(d_id-1) + Wt{d_id})./d_id;
end

% plot figure of averarge synergyW
errt = zeros(EMG_num,syn_num);
for s_id=1:syn_num
    f2 = figure('Position',[900,250*s_id,750,400]);

    % Calculate standard deviation
    errt(:,s_id) = std(Wall(:,(s_id-1)*day_num+1:s_id*day_num),1,2)./sqrt(day_num);

    % plot
    bar(x,aveWt(:,s_id));
    hold on;

    % decoration
    e1 =errorbar(x, aveWt(:,s_id), errt(:,s_id), 'MarkerSize',1);
    ylim([-1 4])
    e1.Color = 'r';
    e1.LineWidth = 2;
    e1.LineStyle = 'none';
    ylim([0 2.5]);
    a = gca;
    a.FontSize = 20;
    a.FontWeight = 'bold';
    a.FontName = 'Arial';
    
    % save figure
    if save_fig == 1
        figure_average_name = ['aveW' sprintf('%d',syn_num) '_' mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',day_num) '_syn' sprintf('%d',s_id)];
        saveas(f2, fullfile(save_figure_folder_path, [figure_average_name '.fig']));
        saveas(f2, fullfile(save_figure_folder_path, [figure_average_name '.png']));
    end
end
close all;
%% save order for next phase analysis
if save_data == 1
    % save data of synergyW
    save_W_data_dir = fullfile(pwd, 'spatial_synergy_data', synergy_combination);
    makefold(save_W_data_dir);
    save_W_data_file_name = [term_group '(' num2str(day_num) 'days)_data.mat'];
    save(fullfile(save_W_data_dir, save_W_data_file_name),"Wt","muscle_name","days")

    % save data which is related to the order of synergy
    save_order_data_dir = fullfile(pwd, 'order_tim_list',  [monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',day_num)]);
    makefold(save_order_data_dir);

    comment = 'this data were made for aveH plot';
    save_order_data_file_name = [monkeyname mat2str(days(1)) 'to' mat2str(days(end)) '_' sprintf('%d',day_num) '_' sprintf('%d',syn_num) '.mat'];
    save(fullfile(save_order_data_dir, save_order_data_file_name), 'k_arr','comment', 'days', 'EMG_num', 'syn_num');
end


%% define local function
function [Wt, k_arr] = OrderSynergy(EMG_num, syn_num, monkeyname, days)
day_num = length(days);

% Create an empty array to store synergy W values
W_data =  cell(1,day_num);

% Read the daily synergy W values & create an array.
for d_id = 1:day_num
    % Load the W synergy data created in the previous phase
    synergy_W_file_path = fullfile(pwd, [monkeyname mat2str(days(d_id)) '_standard'], [monkeyname mat2str(days(d_id)) '_syn_result_' sprintf('%d',EMG_num)], [monkeyname mat2str(days(d_id)) '_W'], [monkeyname mat2str(days(d_id)) '_aveW_' sprintf('%d',syn_num)]);
    load(synergy_W_file_path, 'aveW');
    W_data{d_id} = aveW;
end

% prepare empty array to store data
Wcom = zeros(EMG_num, syn_num);
m = zeros(day_num,syn_num);
Wt = W_data;
k_arr = ones(syn_num, day_num);

% sort data
for s_id = 1:syn_num
    k_arr(s_id, 1) = s_id; % first day
    for d_id = 2:day_num
        % calcurate the error with s_id synergy
        for l = 1:syn_num
            Wcom(:,l) = (W_data{1,1}(:, s_id) - W_data{1, d_id}(:, l)).^ 2; % Square the difference between synergy I on day 1 and synergy l on day d_id
            m(d_id,l) = sum(Wcom(:, l)); % Add the values together (the smallest one should be the corresponding synergy).
        end

        [~, ref_s_id] = min(m(d_id,:));

        % perform sorting with reference to the error
        Wt{1,d_id}(:,s_id) = W_data{1,d_id}(:, ref_s_id);
        k_arr(s_id,d_id) = ref_s_id;

        % assign large value to the used synergy index
        W_data{1, d_id}(:,ref_s_id) = ones(EMG_num,1).*1000;
    end
end
end
