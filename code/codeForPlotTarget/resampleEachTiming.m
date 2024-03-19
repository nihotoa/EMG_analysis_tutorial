%{
=> セッション(日付)ごとに各タイミング付近の切り出しデータ(ref_Ptrig)の長さが違うので、resampleして(時間正規化して)統一するための関数
戻り値は構造体の中の空のcell配列に入る.(時間正規化した各セッションの各筋電(もしくはシナジー)のデータが格納される)
%}

function [ref_Ptrig] = resampleEachTiming(Allfiles_S, ref_Ptrig, ref_timing, nomalizeAmp, select_folder_path, element_num)  
    session_num = length(Allfiles_S);
    for j = 1: session_num 
        % load Pdata
        load(fullfile(select_folder_path, Allfiles_S{j}), 'ResAVE');
        
        % store activity data around the timing of interest in 'data'
        data = eval(['ResAVE.tData' num2str(ref_timing) '_AVE']);
        plotData = zeros(element_num, ref_Ptrig.AllT_AVE);

        % Time normalize to the average sample size of all sessions
        if ref_Ptrig.Tlist(j,1) == ref_Ptrig.AllT_AVE
            for k = 1:element_num%EMG_num loop 
                plotData(k,:) = data{1,k};
            end
        elseif ref_Ptrig.Tlist(j,1)<ref_Ptrig.AllT_AVE 
            for k = 1:element_num%EMG_num loop 
                plotData(k,:) = interpft(data{1,k},ref_Ptrig.AllT_AVE);
            end
        else
            for k = 1:element_num%EMG_num loop 
                plotData(k,:) = resample(data{1,k},ref_Ptrig.AllT_AVE,ref_Ptrig.Tlist(j,1));
            end
        end

        % amplitude normalize (divide each element array by the maximum value of each element)
        if nomalizeAmp
           for mm = 1:element_num
             plotData(mm,:) = plotData(mm,:)./max(plotData(mm,:));
           end
        end
        ref_Ptrig.plotData_sel{j,1} = plotData;
    end
end