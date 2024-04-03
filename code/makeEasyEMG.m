%{
function to concatenate EMG data
this function is used in 'makeEasyData_all.m' & 'save4NMF.m'
input arguments:
    monkeyname: prefix of file name (ex.) 'F'
    xpdate: date of experiment (ex.) 170516
    file_num: list of file number (ex.) [2, 4]
    real_name: full name of monkey (ex.) 'Yachimun'

All of these input arguments can be obtained by executing 'fileInfo.m'
%}

%{
[explanation of this func]:

[input arguments]

[output arguments]

%}

function [AllData_EMG, TimeRange, EMG_Hz] = makeEasyEMG(monkeyname, xpdate, file_num, real_name)
%% Make EMG set(define muscle names for each electrode)
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

%% create EMG All Data matrix
file_count = (file_num(end) - file_num(1)) + 1;
AllData_EMG_sel = cell(file_count,1);
load(fullfile(pwd, real_name, [monkeyname xpdate '-' sprintf('%04d',file_num(1,1))]),'CEMG_001_TimeBegin');
TimeRange = zeros(1,2);
TimeRange(1,1) = CEMG_001_TimeBegin;
EMG_prefix = 'CEMG';
get_first_data = 1;

for i = file_num(1,1):file_num(end)
    for j = 1:EMG_num
        if get_first_data
            load(fullfile(pwd, real_name, [monkeyname xpdate '-' sprintf('%04d',i)]), [EMG_prefix '_001*']);
            EMG_Hz = eval([EMG_prefix '_001_KHz .* 1000;']);
            Data_num_EMG = eval(['length(' EMG_prefix '_001);']);
            AllData1_EMG = zeros(Data_num_EMG, EMG_num);
            AllData1_EMG(:,1) = eval([EMG_prefix '_001;']);
            get_first_data = 0;
        else
            load(fullfile(pwd, real_name, [monkeyname xpdate '-' sprintf('%04d',i)]), [EMG_prefix '_0' sprintf('%02d',j)]);
            eval(['AllData1_EMG(:, j ) = ' EMG_prefix '_0' sprintf('%02d',j) ''';']);
        end
    end
    AllData_EMG_sel{(i - file_num(1, 1)) + 1, 1} = AllData1_EMG;
    load([monkeyname xpdate '-' sprintf('%04d',i)],[EMG_prefix '_001_TimeEnd']);
    TimeRange(1,2) = eval([EMG_prefix '_001_TimeEnd;']);
    get_first_data = 1;
end
AllData_EMG = cell2mat(AllData_EMG_sel);
end