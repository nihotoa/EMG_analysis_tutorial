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
        
        % formatting of data to be plotted
        plot_data = Pdata.plotData_sel{d,1}(m,:);
        if iscell(plot_data)
            plot_data = cell2mat(plot_data);
        end

        switch pColor
            case 'C'
                % datect days_id
                ref_day = days_double(d);
                day_id = find(ref_day == PostDays);
                if isempty(day_id) 
                    close all;
                    error([num2str(ref_day) ' is not included in "PostDays" and cannot be used. Please change "pColor" and run again!'])
                end
                
                % plot
                plot(Pdata.x, plot_data, 'Color', Csp(day_id,:), 'LineWidth', LineW);
            case 'K'
                % plot
                plot(Pdata.x, plot_data, 'k', 'LineWidth', LineW);
        end
    end
end
