%{
[explanation of this func]:
compile a list of names of files containing data to be plotted

[input arguments]
plot_type: [char], this is used to identify the reference folder when launching the dialog
realname: [char], this is used to specify the path (opened as dialog)

[output arguments]
Allfiles_S: [cell array], list of names of selected files
select_folder_path: [char], Absolute path to the location which exists 'Pdata' to be referenced

%}
function [Allfiles_S, select_folder_path] = getFileName(plot_type, realname)
disp("please select '_Pdata.mat' for all the dates you want to plot")
switch plot_type
    case 'EMG'
        select_folder_path = fullfile(pwd, realname, 'easyData', 'P-DATA');
    case 'Synergy'
        select_folder_path = fullfile(pwd, realname, 'new_nmf_result', 'synData');
end

Allfiles_S = uigetfile(fullfile(select_folder_path ,'*_Pdata.mat'), 'Select One or More Files', 'MultiSelect', 'on');
if ischar(Allfiles_S)
    Allfiles_S = {Allfiles_S};
end
end

