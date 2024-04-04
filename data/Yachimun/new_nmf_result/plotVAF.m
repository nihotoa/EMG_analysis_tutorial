%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
[your operation]
1. Go to the directory named 'new_nmf_result(directory where this file exists)''
2. Please change parameters

[role of this code]
Visualize the VAF value of synergy obtained by NNMF and save it as a figure

[Saved figure location]
location: 
    EMG_analysis_tutorial/data/Yachimun/new_nmf_result/VAF_result/

[procedure]
pre: makeEMGNMF_btcOya.m
post: SYNERGYPLOT.m

[Improvement points(Japanaese)]
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
term_type = 'pre'; %pre / post / all 
monkeyname = 'F';
use_style = 'test'; % test/train
VAF_plot_type = 'stack'; %'stack' or 'mean'
VAF_threshold = 0.8; % param to draw threshold_line
font_size = 20; % Font size of text in the figure
surgery_day = 20170530;

%% code section
% Create a list of folders containing the synergy data for each date.
data_folders = dir(pwd);
folderList = {data_folders([data_folders.isdir]).name};
Allfiles_S = folderList(startsWith(folderList, monkeyname));

% Further refinement by term_type
switch term_type
    case 'pre'
        Allfiles_S = Allfiles_S(1:4);
    case 'post'
        Allfiles_S = Allfiles_S(5:end);
    case 'all'
        % no processing
end

Allfiles = strrep(Allfiles_S, '_standard','');
AllDays = strrep(Allfiles, monkeyname, '');
day_num = length(Allfiles_S);

% create the data array of VAF
VAF_data_list = cell(1, day_num);
shuffle_data_list = cell(1, day_num);
for ii = 1:day_num
    VAF_data_path = fullfile(pwd, Allfiles_S{ii}, [Allfiles_S{ii} '.mat']);

    % load VAF data & shuffle data
    VAF_data = load(VAF_data_path, use_style);
    shuffle_data = load(VAF_data_path, 'shuffle');

    % calcurate the average value of VAF for all test (or train) data & shuffle data
    VAF_data_list{ii} = mean(VAF_data.(use_style).r2, 2);
    shuffle_data_list{ii} = mean(shuffle_data.shuffle.r2, 2);
end
VAF_data_list = cell2mat(VAF_data_list);
shuffle_data_list = cell2mat(shuffle_data_list);

% extract number of muscles
[muscle_num, ~] = size(VAF_data_list);

%% plot VAF
f = figure('Position',[100,100,800,600]);
hold on;
x_axis = 1:muscle_num;

% plot VAF of shuffle data
shuffle_mean = mean(shuffle_data_list, 2);
shuffle_std = std(shuffle_data_list, 0, 2);
errorbar((1:muscle_num)', shuffle_mean, shuffle_std, 'o-', 'LineWidth', 2, 'Color', 'blue', 'DisplayName', 'VAF-shuffle');

% plot VAF of actual data
switch VAF_plot_type
    case 'stack'
        color_matrix = zeros(day_num, 3);
        color_vector = linspace(0.4, 1, day_num);
        color_matrix(:, 1) = color_vector;
        day_range = [0 0];
        for ii = 1:day_num
            plot_VAF = VAF_data_list(:, ii);
            
            % plot
            plot(plot_VAF,'LineWidth',2, 'Color', color_matrix(ii, :), HandleVisibility='off');
            plot(plot_VAF,'o','LineWidth',2, 'Color', color_matrix(ii, :), HandleVisibility='off');
            if ii==1
                day_range(1) = CountElapsedDate(AllDays{ii}, surgery_day);
            elseif ii==day_num
                day_range(2) = CountElapsedDate(AllDays{ii}, surgery_day);
            end
        end
        % setting of color bar
        clim(day_range);
        colormap(color_matrix)
        h = colorbar;
        ylabel(h, 'Elapsed day(criterion = TT)', 'FontSize', font_size)
    case 'mean'
        plot_VAF = mean(VAF_data_list, 2);
        plot_VAF_std = std(VAF_data_list, 0, 2);

        % plot
        errorbar((1:muscle_num)', plot_VAF, plot_VAF_std, 'o-', 'LineWidth', 2, 'Color', 'red', 'DisplayName', ['VAF-' num2str(muscle_num) 'EMGs']);
end

% decoration
yline(VAF_threshold,'Color','k','LineWidth',2, HandleVisibility='off')
xlim([0 muscle_num]);
ylim([0 1])
set(gca, 'FontSize', 15)
title(['VAF value at each synergy number(' term_type '=' num2str(day_num) 'days)'], FontSize = font_size);
xlabel('Number of synergy', FontSize=font_size)
ylabel('Value of VAF', FontSize=font_size)
legend('Location','northwest')

grid on;

hold off

%% save figure(as .fig & .png)
save_fold = fullfile(pwd, 'VAF_result');
makefold(save_fold);
saveas(gcf, fullfile(save_fold, ['VAF_result(' term_type '_' num2str(day_num) 'days_' VAF_plot_type ').png']))
saveas(gcf, fullfile(save_fold, ['VAF_result(' term_type '_' num2str(day_num) 'days_' VAF_plot_type ').fig']))
close all

