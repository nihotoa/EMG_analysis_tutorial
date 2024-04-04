%{
[explanation of this func]:
calcurate the Elapsed days from 'reference_day' to 'exp_day'

[input arguments]
exp_day: [double or string], date of exp_day    (ex.) 170526
reference_day: [double or string], date of reference day    (ex.)170530

[output arguments]
Elapsed_date:[double], elapsed days from 'reference_day' to 'exp_day'
%}

function [Elapsed_date] = CountElapsedDate(exp_day, reference_day)
    analyzed_date = trans_calrender(exp_day);
    if not(isdatetime(reference_day))
        reference_day = trans_calrender(reference_day);
    end
    Elapsed_date = between(reference_day, analyzed_date,'Days');
    Elapsed_date = split(Elapsed_date, {'days'});
end

