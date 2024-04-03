function [days] = get_days(InputDirs)
%{
explanation of this func:
Extract the numerical part from each element of InputDirs(cell array) and create a list of double array

input arguments:
InputDirs: [cell array] Each cell contains the string type of the folder name.' You can get it by using 'uiselect'

output arguments:
days: [double array] Each element contains a date of double type
%}

days = zeros(length(InputDirs), 1);
for ii = 1:length(InputDirs)
    ref_element = InputDirs{ii};
    number_part = regexp(ref_element, '\d+', 'match');
    day = str2double(number_part{1});
    days(ii) = day;
end
end