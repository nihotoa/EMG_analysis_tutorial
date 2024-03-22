function [] = plot_stack_figures(data_str, m)
    % stores the field of a structure in a variable of the same name
    field_names = fieldnames(data_str);
    for idx = 1:length(field_names)
        var_name = field_names{idx};
        assignin('base', var_name, data_str.(var_name));
        eval([var_name ' = data_str.' var_name ';'])
    end

    % plot average activity for each session
    for d = 1:session_num
        switch pColor
            case 'C'
                try
                    plot(Pdata.x,cell2mat(Pdata.plotData_sel{d,1}(m,:)),'Color', Csp(d,:), 'LineWidth',LineW);
                catch
                    plot(Pdata.x,Pdata.plotData_sel{d,1}(m,:),'Color',Csp(d,:), 'LineWidth',LineW);
                end
            case 'K'
                try
                    plot(Pdata.x,cell2mat(Pdata.plotData_sel{d,1}(m,:)),'k','LineWidth',LineW);
                catch
                    plot(Pdata.x,Pdata.plotData_sel{d,1}(m,:),'k','LineWidth',LineW);
                end
        end
    end
end
