function [] = gitmotionsecondorderAnalysis(glmstatsmatrix, dates, name, task) 

hFig=figure('Position',[400 200 1200 600],'Name',char(strcat(name,'-',task, '-task-','Bias and Sensitivity from:-',dates(1),'-to-',dates(length(dates)))));
set(hFig,'visible','off');

%seperate rows into vectors for bias across days and sensitivity across days
bias = glmstatsmatrix(1,:);
sensitivity = glmstatsmatrix(2,:);


%produce figures that track changes in bias and sensitivity over time 
hold on;
set(0,'CurrentFigure',hFig)
subplot(2,1,1);
plot(bias, 'Color','b');
set(gca,'xtick',1:10:length(dates),'xticklabel',dates)
title('Bias Across Days');
ylabel('Bias');
xlabel('Day');
hold off;

hold on;
set(0,'CurrentFigure',hFig)
subplot(2,1,2);
plot(sensitivity, 'Color','g');
set(gca,'xtick',1:10:length(dates),'xticklabel',dates)
title('Sensitivity Across Days');
ylabel('Sensitivity');
xlabel('Day');
hold off;

saveas(hFig, char(strcat('/Users/ashkanvafai/Desktop/Cage Training Data/',name,' Figures/Across Days/',name,dates(1),'-through-',dates(length(dates)),task,'.png')));
