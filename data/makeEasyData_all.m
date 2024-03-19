%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
% coded by Naoki Uchida
% last modification : 2024.03.12(by Ota)
this function is used in runnningEasyfunc.m
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [EMGs,Tp,Tp3] = makeEasyData_all(monkeyname, real_name, xpdate_num, file_num, save_fold, mE, task)
%% set parameters
make_EMG = mE.make_EMG;
save_E = mE.save_E;
down_E =  mE.down_E;
make_Timing = mE.make_Timing;
downdata_to = mE.downdata_to;
%% code section
xpdate = sprintf('%d',xpdate_num);
easyData_fold_path = fullfile(pwd, real_name, save_fold);
save_fold_path = fullfile(easyData_fold_path, [monkeyname xpdate '_' task]);

% make save fold
makefold(save_fold_path);
disp(['START TO MAKE & SAVE ' monkeyname xpdate 'file[' sprintf('%d',file_num(1)) ',' sprintf('%d',file_num(end)) ']']);

%% concatenate EMG data from each files(same processing as 'SAVE4NMF.m')
if make_EMG == 1
    [AllData_EMG, TimeRange_EMG, EMG_Hz] = makeEasyEMG(monkeyname, xpdate, file_num, real_name);
end

%% down sampling data
if down_E == 1
   AllData_EMG = resample(AllData_EMG,downdata_to,EMG_Hz);
end

%% cut  data on task timing
if make_Timing == 1
   switch monkeyname
      case {'Su','Se'}
         [Timing,Tp,Tp3,TTLd,TTLu] = makeEasyTiming(monkeyname,xpdate,file_num,downdata_to,TimeRange_EMG);
         % change tiing from 'lever2' to 'photocell'
         errorlist = '';
         emp_d = 0;
         emp_u = 0;
         ph_d = zeros(length(Tp),1); % photo down clock = Photo On
         ph_u = zeros(length(Tp),1); % photo up clock = Photo Off
         for i = 1:length(Tp)
            if isempty(max(TTLd(find((Tp(i,3)<TTLd).*(TTLd<Tp(i,5))))))
                emp_d = 1;
            else
                ph_d(i) = min(TTLd(find((Tp(i,3)<TTLd).*(TTLd<Tp(i,5)))));
            end
            if isempty(max(TTLu(find((Tp(i,3)<TTLu).*(TTLu<Tp(i,5))))))
                emp_u = 1;
            else
                ph_u(i) = max(TTLu(find((Tp(i,3)<TTLu).*(TTLu<Tp(i,5)))));
            end
            if ph_d(i)>ph_u(i) || emp_d == 1 || emp_u ==1
                errorlist = [errorlist ' ' sprintf('%d',i)];
                emp_d = 0;
                emp_u = 0;
            end
            Tp(i,4) = ph_d(i);
            Tp(i,5) = ph_u(i); % Change timings 4 and 5 to 'photo-on' and 'photo-off' timings
         end
         if isempty(errorlist)
         else ER = str2num(errorlist);
             for ii = flip(ER)
                 Tp(ii,:) = [];
             end
         end
           
       otherwise %if reference monkey is not SesekiR or Wasa、（if you don't have to chage to fotocell）
         [Timing,Tp,Tp3] = makeEasyTiming(monkeyname,xpdate,file_num,downdata_to,TimeRange_EMG);
   end
end

%% get data for Cross-Talk check (getCTcheck)
[trial_num, ~] = size(Tp);
CTcheck.data0 = cell(1, trial_num);
CTcheck.data3 = cell(1, trial_num);

% Check for crosstalk for each trial
for n = 1:trial_num
    [crossData, dt3] = getCTcheck(AllData_EMG, Tp, EMG_num, n);
    CTcheck.data0{n} = crossData;
    CTcheck.data3{n} = dt3; 
end

%% save data
if save_E == 1
    Unit = 'uV';
    SampleRate = downdata_to;
    switch monkeyname
        case {'Ya','Ma','F', 'Wa'}
            save(fullfile(save_fold_path, [monkeyname xpdate '_EasyData.mat']), 'monkeyname', 'xpdate', 'file_num', 'EMGs',...
                                                    'AllData_EMG', ...
                                                    'TimeRange_EMG',...
                                                    'EMG_Hz',... '
                                                    'Unit','SampleRate',...
                                                    'Timing','Tp','Tp3');
       case {'Su','Se'}
            save(fullfile(save_fold_path, [monkeyname xpdate '_EasyData.mat']), 'monkeyname', 'xpdate', 'file_num', 'EMGs',...
                                                    'AllData_EMG', ...
                                                    'TimeRange_EMG',...
                                                    'EMG_Hz',... 
                                                    'Unit','SampleRate',...
                                                    'Timing','Tp','Tp3','TTLd','TTLu');
    end
    save(fullfile(save_fold_path, [monkeyname xpdate '_CTcheckData.mat']), 'CTcheck');
    disp(['FINISH TO MAKE & SAVE ' monkeyname xpdate 'file[' sprintf('%d',file_num(1)) ',' sprintf('%d',file_num(end)) ']']);
else
   disp(['NOT SAVE ' monkeyname xpdate 'file[' sprintf('%d',file_num(1)) ',' sprintf('%d',file_num(end)) ']']);
end
end

%% define local function

% Create a cell array of event codes and extract only the event codes for task timing
function [Timing,Tp,Tp3,varargout] = makeEasyTiming(monkeyname, xpdate, file_num, SampleRate, TimeRange_EMG)
Ld = file_num(end)-file_num(1)+1;
%number of file
AllInPort_sel = cell(1,Ld);
get_first_portin = 1;
for i = file_num(1,1):file_num(1,end)
    if get_first_portin
        S1 = load([monkeyname xpdate '-' sprintf('%04d', i) '.mat'], 'CInPort*');
        CInPort = S1.CInPort_001;
    else
        
        S = load([monkeyname xpdate '-' sprintf('%04d', i) '.mat'], 'CInPort_001');
        if ~isempty(struct2cell(S))
           CInPort = S.CInPort_001;
        end
    end
    AllInPort_sel{1,1+i-file_num(1,1)} = CInPort;
    get_first_portin = 0;
end
AllInPort = cell2mat(AllInPort_sel);

%%%%%%%%%%%%%%%%%Define the ID of timing of interest for each experiment%%%%%%%%%%%%%%%%%
switch monkeyname
    case {'Wa','Su','Se'}
        if strcmp(monkeyname, 'Su') || strcmp(monkeyname, 'Se')
            varargout= cell(nargout-4,1);
            AllTTLd_sel = cell(1,Ld);
            AllTTLu_sel = cell(1,Ld);
            count = 1;
            for t = file_num(1):file_num(end)
                TTLdata = load([monkeyname xpdate '-' sprintf('%04d', t) '.mat'], 'CTTL_001*');
                if isfield(TTLdata,'CTTL_001_TimeBegin')
                    TTL_lag = (TTLdata.CTTL_001_TimeBegin - TimeRange_EMG(1))*TTLdata.CTTL_001_KHz*1000;
                    AllTTLd_sel{count} = TTLdata.CTTL_001_Down+TTL_lag;
                    AllTTLu_sel{count} = TTLdata.CTTL_001_Up+TTL_lag;
                    count = count+1;
                end
            end
            if isfield(TTLdata,'CTTL_001_KHz')
                AllTTLd = cell2mat(AllTTLd_sel).*SampleRate./(TTLdata.CTTL_001_KHz*1000);
                AllTTLu = cell2mat(AllTTLu_sel).*SampleRate./(TTLdata.CTTL_001_KHz*1000);
                for n = 1:floor((nargout-4)/2)
                   varargout{n} = AllTTLd;
                   varargout{n*2} = AllTTLu;
                end
            end
        end
        TS = 1092; %trial start
        SPL1 = 1296; %start pulling lever 1
        EPL1 = 80; %end pulling lever 1
        SPL2 = 1104; %start pulling lever 2
        EPL2 = 336; %end pulling lever 2
        ST = 1024; %success trial
        
        TS_2 = 1092; %trial start
        SPL1_2 = 1424; %start pulling lever 1
        EPL1_2 = 80; %end pulling lever 1
        SPL2_2 = 1104; %start pulling lever 2
        EPL2_2 = 464; %end pulling lever 2
        ST_2 = 1024; %success trial
        
    case {'Ya','Ma','F'}
        TS = 34944; %trial start
        SPL1 = 49664; %start pulling lever 1
        EPL1 = 2560; %end pulling lever 1
        SPL2 = 35328; %start pulling lever 2
        EPL2 = 18944; %end pulling lever 2
        ST = 32768; %success trial
        
        TS_2 = 34944; %trial start
        SPL1_2 = 49664; %start pulling lever 1
        EPL1_2 = 2560; %end pulling lever 1
        SPL2_2 = 35328; %start pulling lever 2
        EPL2_2 = 18944; %end pulling lever 2
        ST_2 = 32768; %success trial
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Summarize the sequence of each timing and event code for a successful task.
% (Since there may be two types of event codes depending on the timing, create an array with two patterns)
perfect_task = [TS, SPL1, EPL1, SPL2, EPL2, ST];
perfect_task_2 = [TS_2, SPL1_2, EPL1_2, SPL2_2, EPL2_2, ST_2];
Lp = length(perfect_task);

% Summarize in a cell array at each timing data
Timing_sel = cell(1,Lp);
for ii = 1:Lp
    % Extract elements with timing(ii) event codes from AllInPort
    Timing_alt = AllInPort(:,find((AllInPort(2,:)==perfect_task(ii))+(AllInPort(2,:)==perfect_task_2(ii))));
    % Offset start of TimeRange to 0
    Timing_alt(1,:) = Timing_alt(1,:) - TimeRange_EMG(1) * S1.CInPort_001_KHz * 1000; 
    % Match the sampling frequency after resampling
    Timing_alt(1,:) = floor(Timing_alt(1,:)/(S1.CInPort_001_KHz/(SampleRate/1000)));
    Timing_sel{ii} = Timing_alt;
end

Timing = cell2mat(Timing_sel);

% Sort 'Timing' by the value of the 1st row
[~, I] = sort(Timing(1,:));
Timing = Timing(: ,I); 

% Count the number of elements with the ID of 'success_trial'
suc = find(Timing(2,:)==perfect_task(end)); %
suc_num = length(suc);
perfect3_task = [perfect_task perfect_task perfect_task];

% Search from trial 3 to last trial to see if the condition is satisfied.
Tp_sub = zeros(suc_num-1,Lp);
for s = 3:suc_num 
    if (Timing(2, suc(s)-Lp+1) == perfect_task(1) && Timing(2, suc(s)-Lp+2) == perfect_task(2) && ...
       Timing(2, suc(s)-Lp+3) == perfect_task(3) && Timing(2, suc(s)-Lp+4) == perfect_task(4) && ...
       Timing(2, suc(s)-Lp+5) == perfect_task(5) && Timing(2, suc(s)-Lp+6) == perfect_task(6))||...
       (Timing(2, suc(s)-Lp+1) == perfect_task_2(1) && Timing(2, suc(s)-Lp+2) == perfect_task_2(2) && ...
       Timing(2, suc(s)-Lp+3) == perfect_task_2(3) && Timing(2, suc(s)-Lp+4) == perfect_task_2(4) && ...
       Timing(2, suc(s)-Lp+5) == perfect_task_2(5) && Timing(2, suc(s)-Lp+6) == perfect_task_2(6))

        Tp_sub(s-1,:) = Timing(1, suc(s)-Lp+1:suc(s));
    end
end

% Exclude trials that did not meet the condition (excluding rows with 0)
Tp = Tp_sub(find(Tp_sub(:,1) ~= 0),:);


% Summarize the timing of 3 consecutive successful trials.
Tp3_sub = zeros(suc_num-1,length(perfect3_task));
for s = 4:suc_num
    state = 0;
    for n = 1:3
        if (Timing(2, suc(s)-Lp*n+1) == perfect_task(1) && Timing(2, suc(s)-Lp*n+2) == perfect_task(2) && ...
           Timing(2, suc(s)-Lp*n+3) == perfect_task(3) && Timing(2, suc(s)-Lp*n+4) == perfect_task(4) && ...
           Timing(2, suc(s)-Lp*n+5) == perfect_task(5) && Timing(2, suc(s)-Lp*n+6) == perfect_task(6))||...
           (Timing(2, suc(s)-Lp*n+1) == perfect_task_2(1) && Timing(2, suc(s)-Lp*n+2) == perfect_task_2(2) && ...
           Timing(2, suc(s)-Lp*n+3) == perfect_task_2(3) && Timing(2, suc(s)-Lp*n+4) == perfect_task_2(4) && ...
           Timing(2, suc(s)-Lp*n+5) == perfect_task_2(5) && Timing(2, suc(s)-Lp*n+6) == perfect_task_2(6))
            state = state +1;
        end
    end
    if state == 3
        Tp3_sub(s-3,:) = Timing(1, suc(s)-Lp*3+1:suc(s));
    end
end
Tp3 = Tp3_sub(find(Tp3_sub(:,1) ~= 0),:);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Confirm cross-talk of each other's electrodes
function [pullData, dt3] = getCTcheck(AllData_EMG,Tp, EMG_num, n)
% Create EMG dataset per trial
pullData = zeros(EMG_num,Tp(n,end)-Tp(n,1)+1);
for i = 1:EMG_num
    pullData(i,:) = AllData_EMG(Tp(n,1):Tp(n,end),i)';
end

% Calculate cross-talk
dt3s = cell(EMG_num,1);
h = 1/5000;     % step size

for i = 1:EMG_num
    f = pullData(i, :);
    Ds = diff(f)/h;   
    Ds = diff(Ds)/h;   % second derivative（前のDsをさらにDsする）
    Ds = diff(Ds)/h;
    dt3s{i} = downsample(Ds,10);
end

dt3 = cell2mat(dt3s);
end

