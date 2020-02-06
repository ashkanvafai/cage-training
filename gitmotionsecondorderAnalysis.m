function [] = gitmotionsecondorderAnalysis(glmstatsmatrix, dates)  
%need to pull the glm stats from
%a particular day
%load('/Users/ashkanvafai/Desktop/Cage Training Data/Data Matrices/Shimmy motion glmstatsmatrix');
hFig=figure('Position',[400 200 1200 600],'Name',char(strcat(name,'-',task, '-task-','Bias and Sensitivity from:-',dates(1),'-to-',dates(length(dates)))));
%seperate rows into vectors for bias across days and sensitivity across
%days
bias = glmstatsmatrix(1,:);
sensitivity = glmstatsmatrix(2,:);
%xaxis = [1;2;3]
%dates = {'11/25/2019','12/05/2019','01/21/2020'};

%produce figures that track changes in bias and sensitivity over time 
subplot(2,1,1);
plot(bias, 'Color','b');
set(gca,'xtick',[1:3],'xticklabel',dates)
title('Bias Across Days');
ylabel('Bias');
xlabel('Day');

subplot(2,1,2);
plot(sensitivity, 'Color','g');
set(gca,'xtick',[1:3],'xticklabel',dates)
title('Sensitivity Across Days');
ylabel('Sensitivity');
xlabel('Day');

