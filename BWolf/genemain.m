clc;
clear all;
close all;
format shortG
warning off;

%% Define 

MaxRun = 10; % Max # of run
nPop = 8;
MaxIt = 10;
Ndata = 8 ; % Number Of Dataset
% different methods are used to initialize the different optimization algorithms
% 1= Small initialization  % 2= Random initialization  % 3= Large initialization
Method = 1;

%
OutBGWO1 = zeros(Ndata,MaxRun);
OutBGWO2 = zeros(Ndata,MaxRun);
OutGA = zeros(Ndata,MaxRun);
OutPSO = zeros(Ndata,MaxRun);
PosBGWO1 = zeros(Ndata,MaxRun);
PosBGWO2 = zeros(Ndata,MaxRun);
PosGA = zeros(Ndata,MaxRun);
PosPSO = zeros(Ndata,MaxRun);

global A    ;
%%
fidM = fopen('result Mean(T3).txt','w');
fidB = fopen('result Best(T4).txt','w');
fidW = fopen('result Worst(T5).txt','w');
% fidAVGFish = fopen('result AVGFish(T7).txt','w');
fidAVGSelec = fopen('result AVGSelec(T8).txt','w');
fidS = fopen('result STD(T9).txt','w');

fprintf(fidM,'Table(3):Mean fitness function obtained from the different optimizers using uniform initialization\n');
fprintf(fidB,'Table(4):Best fitness function obtained from the different optimizers using uniform initialization\n');
fprintf(fidW,'Table(5):Worst fitness function obtained from the different optimizers using uniform initialization\n');
%  fprintf(fidAVGFish,'Table(7):Average Fisher Index of the features selected by the different optimizers on the test data using uniform initialization\n');
fprintf(fidAVGSelec,'Table(8):Average selected feature ratio on the average for the different methods using uniform initialization\n');
fprintf(fidS,'Table(9):Standard deviation of the obtained fitness function values over the 20 runs for the different methods using uniform initialization\n');


fprintf(fidM,'Dataset:\tBGWO1\t\tBGWO2\t\tGA\t\t\tPSO \n');
fprintf(fidB,'Dataset:\tBGWO1\t\tBGWO2\t\tGA\t\t\tPSO \n');
fprintf(fidW,'Dataset:\tBGWO1\t\tBGWO2\t\tGA\t\t\tPSO \n');
% fprintf(fidAVGFish,'Dataset:\tBGWO1\t\tBGWO2\t\tGA\t\t\tPSO \n');
fprintf(fidAVGSelec,'Dataset:\tBGWO1\t\tBGWO2\t\tGA\t\t\tPSO \n');
fprintf(fidS,'Dataset:\tBGWO1\t\tBGWO2\t\tGA\t\t\tPSO \n');


%% Main
for d =1:Ndata % Load datasets
    
    addpath(genpath('gene'));
    matFileName = sprintf('dataset%d.mat',d);
    if exist(matFileName, 'file')
        A =load(matFileName);
        A=A.subDs;
        Dim=size(A,2)-1;     % the number of features in the original dataset (Dim)
     
        for Run=1:MaxRun()
            [OutBGWO1(d,Run),PosBGWO1(d,Run)]=bGWO1Cross(nPop,MaxIt,Dim,Method,'Fitness');
            [OutBGWO2(d,Run),PosBGWO2(d,Run)]=bGWO2Sig(nPop,MaxIt,Dim,Method,'Fitness');
           [OutGA(d,Run),PosGA(d,Run)]=GA(nPop,MaxIt,Dim,Method);
            [OutPSO(d,Run),PosPSO(d,Run)]=PSO(nPop,MaxIt,Dim,Method);
        end
    else
        fprintf('File %s does not exist.\n', matFileName);
    end
    
    
    Mean_BGWO1(d)=mean(OutBGWO1(d,:));                                 %#ok    % Equation (31)
    Best_BGWO1(d)=min(OutBGWO1(d,:));                                  %#ok    % Equation (29)
    Worst_BGWO1(d)=max(OutBGWO1(d,:));                                 %#ok    % Equation (30)
    Std_BGWO1(d)=std(OutBGWO1(d,:));                                   %#ok    % Equation (32)
%   AvgFish_BGWO1(d)=fexact(PosBGWO1(d,:)',PosBGWO1(d,:)','tail','r')  %#ok    % Equation (34)
    AvgSelec_BGWO1(d)=(mean(PosBGWO1(d,:))/Dim);                       %#ok    % Equation (33)
    
    % BGWO2 Algorithm
    Mean_BGWO2(d)=mean(OutBGWO2(d,:));                                 %#ok    % Equation (31)
    Best_BGWO2(d)=min(OutBGWO2(d,:));                                  %#ok    % Equation (29)
    Worst_BGWO2(d)=max(OutBGWO2(d,:));                                 %#ok    % Equation (30)
    Std_BGWO2(d)=std(OutBGWO2(d,:));                                   %#ok    % Equation (32)
%   AvgFish_BGWO2(d)=fexact(PosBGWO2(d,:)',PosBGWO2(d,:)','tail','r')  %#ok    % Equation (34)
    AvgSelec_BGWO2(d)=(mean(PosBGWO2(d,:))/Dim);                       %#ok    % Equation (33)    

    % GA Algorithm
    Mean_GA(d)=mean(OutGA(d,:));                                       %#ok    % Equation (31)
    Best_GA(d)=min(OutGA(d,:));                                        %#ok    % Equation (29)
    Worst_GA(d)=max(OutGA(d,:));                                       %#ok    % Equation (30)
    Std_GA(d)=std(OutGA(d,:));                                         %#ok    % Equation (32)
%   AvgFish_GA(d)=fexact(PosGA(d,:)',PosGA(d,:)','tail','r')           %#ok    % Equation (34)
    AvgSelec_GA(d)=(mean(PosGA(d,:))/Dim);                             %#ok    % Equation (33)    
    
    % PSO Algorithm
    Mean_PSO(d)=mean(OutPSO(d,:));                                     %#ok    % Equation (31)
    Best_PSO(d)=min(OutPSO(d,:));                                      %#ok    % Equation (29)
    Worst_PSO(d)=max(OutPSO(d,:));                                     %#ok    % Equation (30)
    Std_PSO(d)=std(OutPSO(d,:));                                       %#ok    % Equation (32)
%   AvgFish_PSO(d)=fexact(PosPSO(d,:)',PosPSO(d,:)','tail','r')        %#ok    % Equation (34)
    AvgSelec_PSO(d)=(mean(PosPSO(d,:))/Dim);                           %#ok    % Equation (33)
    
    
    fprintf(fidM,'D%d:\t\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',d,Mean_BGWO1(d),Mean_BGWO2(d),Mean_GA(d),Mean_PSO(d));
    fprintf(fidB,'D%d:\t\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',d,Best_BGWO1(d),Best_BGWO2(d),Best_GA(d),Best_PSO(d));
    fprintf(fidW,'D%d:\t\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',d,Worst_BGWO1(d),Worst_BGWO2(d),Worst_GA(d),Worst_PSO(d));
%   fprintf(fidAVGFish,'D%d:\t\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',d,AvgFish_BGWO1(d),AvgFish_BGWO2(d),AvgFish_GA(d),AvgFish_PSO(d));
    fprintf(fidAVGSelec,'D%d:\t\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',d,AvgSelec_BGWO1(d),AvgSelec_BGWO2(d),AvgSelec_GA(d),AvgSelec_PSO(d));
    fprintf(fidS,'D%d:\t\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',d,Std_BGWO1(d),Std_BGWO2(d),Std_GA(d),Std_PSO(d));
    
    
    
end
fprintf(fidM,'--------------------------------------------------------------------------------------------------\n');
fprintf(fidM,'Total:\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',sum(Mean_BGWO1),sum(Mean_BGWO2),sum(Mean_GA),sum(Mean_PSO));
fprintf(fidB,'--------------------------------------------------------------------------------------------------\n');
fprintf(fidB,'Total:\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',sum(Best_BGWO1),sum(Best_BGWO2),sum(Best_GA),sum(Best_PSO));
fprintf(fidW,'--------------------------------------------------------------------------------------------------\n');
fprintf(fidW,'Total:\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',sum(Worst_BGWO1),sum(Worst_BGWO2),sum(Worst_GA),sum(Worst_PSO));
fprintf(fidAVGSelec,'--------------------------------------------------------------------------------------------------\n');
fprintf(fidAVGSelec,'Avrage:\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',mean(AvgSelec_BGWO1),mean(AvgSelec_BGWO2),mean(AvgSelec_GA),mean(AvgSelec_PSO));


% %% % Equation (35)
% fidWi=fopen('Wilcoxon(T10).txt','w');
% fprintf(fidWi,'Table(10): The Wilcoxon test for the average fitness obtained by the different optimizers\n');
% fprintf(fidWi,'Dataset:\tBGWO1\t\tBGWO2\n');
% BGWO12GA= ranksum(Best_BGWO1,Best_GA);
% BGWO12PSO= ranksum(Best_BGWO1,Best_PSO);
% BGWO22GA= ranksum(Best_BGWO2,Best_GA);
% BGWO22PSO= ranksum(Best_BGWO2,Best_PSO);
% fprintf(fidWi,'GA:\t\t\t%0.3f\t\t%0.3f\t\t\n',BGWO12GA,BGWO22GA);
% fprintf(fidWi,'PSO:\t\t%0.3f\t\t%0.3f\t\t\n',BGWO12PSO,BGWO22PSO);
% fclose(fidWi);
fclose(fidM);fclose(fidB);fclose(fidW);fclose(fidAVGSelec);fclose(fidS);
% fclose(fidAVGFish);


%% Figure

Y = [ mean(Mean_BGWO1),mean(Best_BGWO1),mean(Worst_BGWO1)
    mean(Mean_BGWO2),mean(Best_BGWO2),mean(Worst_BGWO2)
    mean(Mean_GA),mean(Best_GA),mean(Worst_GA)
    mean(Mean_PSO),mean(Best_PSO),mean(Worst_PSO)];

Z = [mean(Std_BGWO1),mean(Std_BGWO2),mean(Std_GA),mean(Std_PSO)];

figure(1)
h=bar(Y,'FaceColor',[0 .5 .5],'EdgeColor',[0 .9 .9],'LineWidth',1.5);
hold on;
grid on;
% title('Small Initialization')
title('Large Initialization')
Labels = {'bGWO1', 'bGWO2', 'GA', 'PSO'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
l = cell(1,3);
l{1}='Mean Fitness'; l{2}='Best Fitness'; l{3}='Worst Fitness';
legend(h,l,'Location','EastOutside','Orientation','vertical');
legend('boxoff')
set(h(1),'facecolor',[0.08 0.39 0.75])  % use color name
set(h(2),'facecolor',[0.95 0.26 0.21])   % use color name
set(h(3),'facecolor',[0 0.78 0.32])   % use color name
saveas(gcf,'MBWL.png')
saveas(gcf,'MBWL.fig')
% saveas(gcf,'MBWS.png')
% saveas(gcf,'MBWS.fig')



figure(2)
G=bar(Z,'FaceColor',[0.08 0.39 0.75],'EdgeColor',[0 .9 .9],'LineWidth',1.5);
hold on;
grid on;
title('Std Of Fitness')
Labels = {'bGWO1', 'bGWO2', 'GA', 'PSO'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
saveas(gcf,'StdLarge.png')
saveas(gcf,'StdLarge.fig')
% saveas(gcf,'StdSmall.png')
% saveas(gcf,'StdSmall.fig')


