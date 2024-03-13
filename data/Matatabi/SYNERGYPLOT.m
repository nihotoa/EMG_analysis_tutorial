%% set param
monkeyname = 'Ma';
%28
days = [...
        %pre-surgery
%         170327;...
%         170328;...
%         170329
        %post-surgery
%         170612;...
%         170614;...
%         170621;...
%         170622;...
%         170623;...
%         170627;...
%         170628;...
%         170629;...
%         170630;...
%         170703;...
%         170704;...
%         170705;...
%         170706;...
%         170707;...
%         170710;...
%         170711;...
%         170712;...
% %         170713;...
%         170714;...
%         170718;...
%         170719;...
%         170720;...
%         170725;...
%         170726;...
%         170801;...
%         170803;...
%         170804;...
%         170807;...
%         170808;...
%         170809;...
%         170810;...
%         170815;...
%         170816;...
%         170817;...
%         170818;...
%         170822;...
%         170823;...
% %         170824;...
% %         170825;...
%         170829;...
% %         170830;...
%         170831;...
%         170901;...
%         170904;...
%         170905;...
%         170906;...
%         170908;...
%         170911;...
%         170913;...
%         170914;...
% %         170919;...
        170926;...
        170927;...
        170929;...
%         171002;...
        171003;...
        171004;...
        171005;...
        171011;...
        171012
         ];
Ld = length(days);
     
for ii = 1:Ld
    fold_name = [monkeyname sprintf('%d',days(ii))];
    synergyplot_func(fold_name);
end
