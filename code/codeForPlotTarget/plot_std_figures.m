function [] = plot_std_figures(data_str, m)
    % stores the field of a structure in a variable of the same name
    field_names = fieldnames(data_str);
    for idx = 1:length(field_names)
        var_name = field_names{idx};
        assignin('base', var_name, data_str.(var_name));
        eval([var_name ' = data_str.' var_name ';'])
    end

    % plot background by refering to std
    sd = Pdata.SD{m};
    y = Pdata.AVE{m};
    xconf = [Pdata.x Pdata.x(end:-1:1)];
    yconf = [y+sd y(end:-1:1)-sd(end:-1:1)];
    fi = fill(xconf,yconf,'k');
    fi.FaceColor = [0.8 0.8 1]; % make the filled area pink
    fi.EdgeColor = 'none'; % remove the line around the filled area

    % plot averarge data
    plot(Pdata.x,y,'k','LineWidth',LineW);
end
