function [] = makefold(folder_path)
%{
[explanation of this func]:
Create a directory only if the folder at the path specified by the input argument dones not exist

[input arguments]:
folder_path: [char], Either absolute or relative path.
(ex.) 'EMG_analysis_tutorial/data/Yachimun/easyData'
%}
if not(exist(folder_path))
    mkdir(folder_path)
end
end

