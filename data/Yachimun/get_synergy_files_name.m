function [synergy_files] = get_synergy_files_name(fold_path, fold_name)
%{
explanation of this func:
get the names of synergy-related files in a folder by list
this function is used in plotSynergyAll_uchida.m

input arguments:
fold_path: [char], folder path of '_standard' folder    (ex.) 'EMG_analysis_tutorial/data/Yachimun/new_nmf_result/F170516_standard'
fold_name: [char], prefix + date    (ex.) 'F170516' 

output arguments:
synergy_files: [struct], Structure of the file containing 'fold_name' string. (The structure has the same form as that obtained by the 'dir' function)
%}

candidate_files = dir(fold_path);

% filtering (Leaves only files)
candidate_files = candidate_files(~[candidate_files.isdir]);

% extract only files with specific strings(fold_name)
synergy_files = candidate_files(contains({candidate_files.name}, fold_name));
end

