function [P_ref] = makeSDdata(P_ref, session_num, element_num)

% create empty array to store data
SDdata = cell(session_num,1);
P_ref.SD = cell(element_num,1);
P_ref.AVE = cell(element_num,1);

% For each EMG(or synergy), find the mean and standard deviation for all sessions
for m = 1:element_num
    for d = 1:session_num
        % The structure of 'plotData_sel' differs between 'Pall' and others, so deal with this.
        try
            SDdata{d} = cell2mat(P_ref.plotData_sel{d,1}(m,:));
        catch
            SDdata{d} = P_ref.plotData_sel{d,1}(m,:);
        end
    end
    P_ref.SD{m} = std(cell2mat(SDdata), 1, 1);
    P_ref.AVE{m} = mean(cell2mat(SDdata), 1);
end
end

