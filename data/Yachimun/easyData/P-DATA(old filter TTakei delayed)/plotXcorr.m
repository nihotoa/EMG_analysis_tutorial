%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
�y�ۑ�z
�E�^�X�N�S�̂����x_corr�̐}���̃Z�N�V�����͉��P���Ă��Ȃ��̂ŁA���s�ł��Ȃ�(plot_all = 1�͎��s�ł��Ȃ�)
�@�� ��������P����ꍇ�͂��̊֐����C������O��,calcXcorr.m��ResultXcorr~.mat�ɕۑ������ϐ��̓��e���m�F����K�v������
�Eplot_each��subplot�̂Ƃ���̔ėp�����Ⴂ(t = 2:3 (T2,T3)�ɂ����Ή����Ă��Ȃ�)
�yprocedure�z
pre : calcXcorr.m
post : plotXcorr_W.m
�ycaution!!�z
AllDays,dayX,visual_syn�͓K�X�ύX���邱��

[���P�_]
����Ȃ��Ƃ������� & �ǐ��Ⴂ
2,4���v���b�g�Ƃ��鎞��1,3���v���b�g���鎞�Ŗ��O���ꏏ�ɂȂ��Ă��܂��̂ŕ�����
�ǂ̕ϐ��ς���΂����̂������肸�炢
AllDays��dayX��ς��Ȃ��Ⴂ���Ȃ��̂��߂�ǂ�����
RexultXcorr�̂Ȃ���Tar�����邽�߁C�㏑������Ă��܂�.(�ŏ��ɒ�`����Tar�̈Ӗ����Ȃ��Ȃ��Ă��܂�)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
%% set param
Tar = 'Synergy'; %'EMG' / 'Synergy'
save_data = 1;
save_fig = 1;
plotFocus = 'off';
plot_all = 0; %if you want to plot x_corr which is extracted from all range of task, please set '1'
plot_each = 1;% if you want to plot x_corr which is extracted from around each timing of task, please set '1'
synergy_combination = 'dist-dist'; %dist-dist,dist-prox,prox-dist,prox-prox (procedure is EDC-FDS)
vidual_syn =  [2,4]; %please select the synergy group which you want to plot!!
plot_timing = [1,2,3,4];
title_name = {'lever1 on','lever1 off','lever2 on','lever2 off'};
% figure;

%% plot crosscorrelation
switch Tar
   case 'EMG'
%       load('ResultXcorr_80.mat');
%       load('ResultXcorr_Each_EMG_Range2.mat');      
    %load ResultXcorr
      disp('please select ResultXcorr_~.mat file (which you want to plot x_corr)')
      selected_file = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
      load(selected_file);
    %load ResultXcorr_Each~
      disp('please select ResultXcorr_Each~.mat file (which you want to plot each x_corr)')
      selected_file = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
      load(selected_file);    

   case 'Synergy'
    %load ResultXcorr
      disp('please select ResultXcorr_~.mat file (which you want to plot x_corr)')
      selected_file = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
      load(selected_file);
    %load ResultXcorr_Each~
      disp('please select ResultXcorr_Each~.mat file (which you want to plot each x_corr)')
      selected_file = uigetfile('*.mat',...
                     'Select One or More Files', ...
                     'MultiSelect', 'on');
      load(selected_file);    
end

switch Tar
   case 'EMG'
      c = jet(12);
%       AllDays = datetime([2017,04,05])+caldays(0:177);
      AllDays = datetime([2017,05,16])+caldays(0:136); %5/16��136���o�� �� 9/29
%       dayX = {'2017/04/05','2017/04/10','2017/04/11','2017/04/12','2017/04/13',...
%               '2017/04/19','2017/04/20','2017/04/21','2017/04/24','2017/04/25',...
%               '2017/04/26','2017/05/01','2017/05/09','2017/05/11','2017/05/12',...
%               '2017/05/15','2017/05/16','2017/05/17','2017/05/24','2017/05/26',...
%               '2017/05/29','2017/06/06','2017/06/08','2017/06/12','2017/06/13',...
%               '2017/06/14','2017/06/15','2017/06/16',...'2017/06/19',
%               '2017/06/20',...
%               '2017/06/21','2017/06/22','2017/06/23','2017/06/27','2017/06/28',...
%               '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
%               '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
%               '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
%               '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
%               '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
%               '2017/08/18','2017/08/22','2017/08/23','2017/08/24','2017/08/25',...
%               '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
%               '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
%               '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%81days
%       dayX = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26','2017/06/28',...
%               '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
%               '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
%               '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
%               '2017/07/26','2017/08/02','2017/08/04','2017/08/07',...
%               '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
%               '2017/08/18','2017/08/22','2017/08/24','2017/08/25',...
%               '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
%               '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
%               '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%49days(removed 8/3, 8/23)
      dayX = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26','2017/06/28',...
              '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
              '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
              '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
              '2017/07/26','2017/08/02','2017/08/03', '2017/08/04','2017/08/07',...
              '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
              '2017/08/18','2017/08/22','2017/08/23','2017/08/24','2017/08/25',...
              '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
              '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
              '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%51days(not removed)
   case 'Synergy'
      c = lines(4);
%       c = jet(4);
      AllDays = datetime([2017,05,16])+caldays(0:136); %5/16��136���o�� �� 9/29
      dayX = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26','2017/06/28',...
              '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
              '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
              '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
              '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
              '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
              '2017/08/18','2017/08/22','2017/08/23','2017/08/24','2017/08/25',...
              '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
              '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
              '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%51days

%       dayX = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26','2017/06/28',...
%               '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
%               '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
%               '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
%               '2017/07/26','2017/08/02','2017/08/04','2017/08/07',...
%               '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
%               '2017/08/18','2017/08/22','2017/08/24','2017/08/25',...
%               '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
%               '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
%               '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%49days(removed 8/3, 8/23)

%         dayX = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26','2017/06/28',...
%           '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
%           '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
%           '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
%           '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
%           '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/24',...
%           '2017/08/29','2017/08/30','2017/09/01',...
%           '2017/09/05','2017/09/06',...
%           '2017/09/14','2017/09/25'};%37days
%       AllDays = datetime([2017,04,05])+caldays(0:177);
%       dayX = {'2017/04/05','2017/04/10','2017/04/11','2017/04/12','2017/04/13',...
%               '2017/04/19','2017/04/20','2017/04/21','2017/04/24','2017/04/25',...
%               '2017/04/26','2017/05/01','2017/05/09','2017/05/11','2017/05/12',...
%               '2017/05/15','2017/05/16','2017/05/17','2017/05/24','2017/05/26',...
%               '2017/05/29','2017/06/06','2017/06/08','2017/06/12','2017/06/13',...
%               '2017/06/14','2017/06/15','2017/06/16','2017/06/20',...
%               '2017/06/21','2017/06/22','2017/06/23','2017/06/27','2017/06/28',...
%               '2017/06/29','2017/06/30','2017/07/03','2017/07/04','2017/07/06',...
%               '2017/07/07','2017/07/10','2017/07/11','2017/07/12','2017/07/13',...
%               '2017/07/14','2017/07/18','2017/07/19','2017/07/20','2017/07/25',...
%               '2017/07/26','2017/08/02','2017/08/03','2017/08/04','2017/08/07',...
%               '2017/08/08','2017/08/09','2017/08/10','2017/08/15','2017/08/17',...
%               '2017/08/18','2017/08/22','2017/08/23','2017/08/24','2017/08/25',...
%               '2017/08/29','2017/08/30','2017/08/31','2017/09/01','2017/09/04',...
%               '2017/09/05','2017/09/06','2017/09/07','2017/09/08','2017/09/11',...
%               '2017/09/13','2017/09/14','2017/09/25','2017/09/26','2017/09/27','2017/09/29'};%80days
end

AVEPre4Days = {'2017/05/16','2017/05/17','2017/05/24','2017/05/26'};
TaskCompletedDay = {'2017/08/07'};
TTsurgD = datetime([2017,05,30]);                %date of tendon transfer surgery
TTtaskD = datetime([2017,06,28]);                %date monkey started task by himself after surgery & over 100 success trials (he started to work on June.28)
Xpost = zeros(size(AllDays));
Xpre4 = zeros(size(AllDays));
k=1;l=1;
for i=1:length(AllDays)
   if k>length(dayX)
   elseif AllDays(i)==dayX(k)
       Xpost(1,i) = i;
       k=k+1;
   end
   if l>length(AVEPre4Days)
   elseif AllDays(i)==AVEPre4Days(l)
       Xpre4(1,i) = i;
       l=l+1;
   end
   if AllDays(i)==TaskCompletedDay
      tcd = i;
   end
end
xdays = find(Xpost) - find(AllDays==TTsurgD);
xPre4days = find(Xpre4) - find(AllDays==TTsurgD);
TCD = tcd - find(AllDays==TTsurgD);
xnoT = 0:(find(AllDays==TTtaskD)-1- find(AllDays==TTsurgD));
Ptype = 'RAW';                                     %Plot Type : 'RAW' or 'MMean'( move mean )
np = 3;                                            %smooth num
kernel = ones(np,1)/np; 
delSyn = [0,0,0,0];%delete plots which synergy belongs to
delEMG = [1,1,0,0,1,1,1,1,1,0,0,1];
LEMGs = cell(1,12);

%% plot Xcorr Each
if plot_each == 1
    switch Tar
       case 'EMG'
          % �}�̍\���̂̍쐬
           figure_str = struct;
           [EMG_num, ~] = size(EMGs);
           figure_num = ceil(EMG_num/4);  % �쐬����}�̐� 
           for ii = 1:figure_num
                eval(['figure_str.f' sprintf('%d',ii) '= figure(''Position'',[0 0 ' num2str(300 * length(plot_timing)) ' 1000]);']);
           end
           
           for t = plot_timing %�^�C�~���O���Ƃ�loop
        %       f = figure('Position',[0 0 2000 1000]);
              k = 1;  % �g��������ł͂��邪,�d�v����
              switch plotFocus
                case 'off'
%                        % �}�̍\���̂̍쐬
%                        figure_str = struct;
%                        [EMG_num, ~] = size(EMGs);
%                        figure_num = ceil(EMG_num/4);  % �쐬����}�̐� 
%                        for ii = 1:figure_num
%                             eval(['figure_str.f' sprintf('%d',ii) '= figure(''Position'',[0 0 ' num2str(300 * length(plot_timing)) ' 1000]);']);
%                        end
                       Jloop = 1:EMG_num;   %�ؓ���, �v���b�g���鏇��
                    case 'on'
                       if t==1
                          fe = figure('Position',[0 0 2000 1000]);
                       else
                          figure(fe)
                       end
                       Jloop = [4 3 10 11];
               end
              for j=Jloop % ���ԂɊe�ؓ���x_corr���v���b�g���Ă��� 
                   eval(['plotDe = ResE.T' sprintf('%d',t) ';']);  % �^�C�~���Ot�̃f�[�^�����o��
                   switch plotFocus
                      case 'off'
                            page_num = ceil(j/4);  %�����ڂ̐}�Ƀv���b�g?
                            eval(['figure(figure_str.f'  num2str(page_num) ')']) %�}��gcf�ɂ���
                            height_num = j - (page_num-1) * 4;  %�ォ�牽�ԖڂɃv���b�g?
                            location_num = length(plot_timing) * (height_num-1) + find(t==plot_timing);
                            subplot(4, length(plot_timing), location_num)
                      case 'on'
                         subplot(4,4,4*(k-1)+t);
                         k = k+1;
                   end
    
              %      f = figure;
                   hold on;
                   % area for control data %�R���g���[���f�[�^�̃G���A���D�F�ɐ��߂�
                   fi1 = fill([xPre4days xPre4days(end:-1:1)],[ones(size(xPre4days)) (-1).*ones(size(xPre4days))],'k'); %�悭�킩��Ȃ����Ǐd�v
                   fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
                   fi1.EdgeColor = 'none';            % remove the line around the filled area
                   hold off;
                   p = cell(12,1);
                  for i = j %1:12 %control vs each_day��each_day�̕��̋ؓ�(����͓����ؓ����m�݂̂��������̂�,i = j)
                     spp =1;
                      hold on;
                      switch Ptype
                         case 'RAW'
                            p{i} = plot(xdays,plotDe{j}(i,:),'LineWidth',1.3);
                         case 'MMean'
                            p{i} = plot(xdays,conv2(plotDe{j}(i,:),kernel,'same'),'Color',c(i,:),'LineWidth',1.3);
                      end
%                       if (delEMG(i))  % �悭�킩��Ȃ�(plot�������̂�����?)
%                           delete(p{i});
%                       end
                  end
                  spp = spp+1;
                  plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
                  % �v���s�\�̕�����box�ň͂�
                  fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k','LineWidth',1.3); 
                  fi2.FaceColor = [1 1 1];       % make the filled area
        %           fi2.EdgeColor = 'none';            % remove the line around the filled area
                  hold off;
                  % decoration
                  ylim([-1 1]);
                  xlim([xPre4days(1) xdays(end)]);
                  title([EMGs{j,1} ' ' title_name{t}],'FontSize',15);
              end
           end
           % �}�̕ۑ�
           if save_fig == 1
               %save_fold�̍쐬
               save_fold = 'EachPlot/x_corr_result/EMG';
               save_fold_path = fullfile(pwd, save_fold);
               if not(exist(save_fold_path))
                   mkdir(save_fold_path)
               end
               %�}���ꖇ���ۑ�
               for ii = 1:figure_num
                    eval(['figure(figure_str.f'  num2str(ii) ')'])
                    saveas(gcf, [save_fold_path '/' 'EMG_xcorr(' num2str(EMG_num) 'muscle)_page' num2str(ii) '.fig'])
                    saveas(gcf, [save_fold_path '/' 'EMG_xcorr(' num2str(EMG_num) 'muscle)_page' num2str(ii) '.png'])
               end
           end
           close all
       %% case of synergy analysis
       case 'Synergy'
          TarN =4; %�V�i�W�[��
          %��t:T2~T3�̃v���b�g(food on��food off (tim1,tim4�͕s�v�Ȃ̂Ŕr��))
          for t = plot_timing %1:TarN %trig loop 
        %       f = figure('Position',[0 0 2000 1000]);
              k = 1;
              switch plotFocus
                    case 'off'
                       if t == plot_timing(1) %1��ڂ̃��[�v�̎�,figure���쐬 
                            eval(['f' sprintf('%d',k) '= figure(''Position'',[0 0 ' num2str(300 * length(plot_timing)) ' 1000]);']);
                       end
                       Jloop = 1:TarN;
                    case 'on'
                       if t==1
                          fe = figure('Position',[0 0 2000 1000]);
                       else
                          figure(fe);
                       end
                       Jloop = [2 1 4 3];
              end
              for j=Jloop %j�́u�V�i�W�[j�̃R���g���[���ɑ΂���v��\���Ă���
                   eval(['plotDe = ResE.T' sprintf('%d',t) ';']);
                   if j == 1
                       for pp = 1:4
                           eval(['vs_tim' num2str(t) '_synergy' num2str(pp) '= plotDe{' num2str(pp) '};'])
                       end
                   end
                   switch plotFocus
                      case 'off'
%                          subplot(TarN,2,(2*j)-(plot_timing(2)-t)); %2��(2*j)�̓^�C�~���O�̐�(T2��T3),(plot_timing(2)-t)��plot_timing(2)��t�̈�ԍŌ�̗v�f�̒l�������Ă���
                           timing_num = length(plot_timing);
                           subplot(TarN,length(plot_timing), timing_num*(j-1) + find(t == plot_timing)); %2��(2*j)�̓^�C�~���O�̐�(T2��T3),(plot_timing(2)-t)��plot_timing(2)��t�̈�ԍŌ�̗v�f�̒l�������Ă���
                      case 'on'
                         subplot(TarN,4,4*(k-1)+t);
                         k = k+1;
                   end

              %      f = figure;
                   hold on;
                   % area for control data
                   fi1 = fill([xPre4days xPre4days(end:-1:1)],[ones(size(xPre4days)) (-1).*ones(size(xPre4days))],'k');
                   fi1.FaceColor = [0.78 0.78 0.78];       % make the filled area
                   fi1.EdgeColor = 'none';            % remove the line around the filled area
        % %            % area for disable term
        % %            fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k');
        % %            fi2.FaceColor = [0.5 0.5 0.6];       % make the filled area
        % %            fi2.EdgeColor = 'none';            % remove the line around the filled area
                   hold off;
                   p = cell(TarN,1);
                   spp = 1;
                  for i = vidual_syn %[2 1 4 3]%1:TarN %EMG control loop
              %         subplot(12,12,12*(j-1)+i);
                      hold on;
              %         p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(i,:),'LineWidth',1.3);
                      switch Ptype
                         case 'RAW'
                            p{i} = plot(xdays,plotDe{j}(i,:),'Color',c(spp,:),'LineWidth',1.3, 'DisplayName',['Synergy' num2str(i)]);
                            %{
                            syn1A~syn4A���A����ȍ~�̃Z�N�V�����Ŏg�p����Ă��Ȃ��̂ŁA�R�����g�A�E�g����
                            if t == 1
                               if j==2
                                  syn1A(spp,:) = plotDe{j}(i,:);
                               elseif j==1
                                  syn2A(spp,:) = plotDe{j}(i,:);
                               elseif j==4
                                  syn3A(spp,:) = plotDe{j}(i,:);
                               elseif j==3
                                  syn4A(spp,:) = plotDe{j}(i,:);
                               end
                            end
                            %}
                         case 'MMean'
              %               ps{i} = scatter(xdays,plotDe{j}(i,:));
                            p{i} = plot(xdays,conv2(plotDe{j}(i,:),kernel,'same'),'Color',c(spp,:),'LineWidth',1.3);
                      end
                      spp = spp+1;
                  end
                  %plot([TCD TCD],[-1 1],'k--','LineWidth', 1.3);
                   % area for disable term
                  fi2 = fill([xnoT xnoT(end:-1:1)],[ones(size(xnoT)) (-1).*ones(size(xnoT))],'k','LineWidth',1.3);
                  fi2.FaceColor = [1 1 1];       % make the filled area
        %           fi2.EdgeColor = 'none';            % remove the line around the filled area

                  hold off;
                  if(delSyn(1))
                     delete(p{1});
                  end
                  if(delSyn(2))
                     delete(p{2});
                  end
                  if(delSyn(3))
                     delete(p{3});
                  end
                  if(delSyn(4))
                     delete(p{4});
                  end
                  ylim([-1 1]);
                  xlim([xPre4days(1) xdays(end)]);
              %     xlim([xdays(1) xdays(end)]);
              %     xlim([0 81]);
                  title([title_name{t} ' Synergy' num2str(j)]);
                  %title(['vs Syn' num2str(j) '(T' num2str(t) ')'],'FontSize',25);
                  if j == TarN
                      ylabel('Cross-correlation coefficient');
                      xlabel('Post tendon transfer [days]');
                  end
              end
          end
          % legend�p�Ɏg�p����line���܂Ƃ߂�
          count = 1;
          for ii = 1:length(p)
              if ~isempty(p{ii})
                  a(count) = p{ii};
                  count = count+1;
              end
          end
          lgd = legend(a([1:end]));
          lgd.FontSize = 8;
          %save figure
          if save_fig == 1
              save_dir = ['EachPlot/x_corr_result/' synergy_combination];
              if not(exist(save_dir))
                  mkdir(save_dir)
              end
              fig_name = [save_dir '/' num2str(TarN) 'syn_' num2str(length(vidual_syn)) 'plot_' num2str(length(plot_timing)) 'timing'];
              saveas(gcf,[fig_name '.fig']);
              saveas(gcf,[fig_name '.png']);
          end
          close all;
          %save data
          if save_data == 1
              save_dir = ['EachPlot/x_corr_result/' synergy_combination];
              if not(exist(save_dir))
                  mkdir(save_dir)
              end
              save([save_dir '/x_corr_data(temporal).mat'],'vs*','xdays','dayX')
          end
    end
end