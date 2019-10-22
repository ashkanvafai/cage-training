clear variables 
close all  
%-----------------------------------------------------------------------%
%% 
%Psychometric Function for Color data
global colordatamatrix;

cohVector = colordatamatrix(:,8);
accVector = colordatamatrix(:,14);

cohList = unique(cohVector);

for i=1:length(cohList)
    meanvector1(i) = mean(accVector(cohVector==cohList(i)))
end


%subplot(2,2,2);
plot(cohList,meanvector1, 'Color','r');
title('Accuracy vs. Coherence');
ylabel('Accuracy');
xlabel('Coherence');
%-----------------------------------------------------------------------%
%%


dirVector = colordatamatrix(:,7);
cohVector = colordatamatrix(:,8);
meanVector = [];
for i=1:length(cohVector)
    if dirVector(i) == 0
        correcter = cohVector(i);
        cohVector(i) = (1 - correcter);
    end
end

choiceVector = colordatamatrix(:,13);
cohList = unique(cohVector);

for i=1:length(cohList)
    meanvector(i) = mean(choiceVector(cohVector==cohList(i)))
end

meanvectors = meanvector';

glmstats = glmfit(cohList,meanvectors,'binomial');
%yfit = glmstats(1) + (glmstats(2)*cohList);
yfit(:,1) = glmval(glmstats(:,1),cohList(:,1), 'logit');

subplot(2,2,1);
hold on 
scatter(cohList,meanvector);
plot(cohList, yfit, 'Color','r');
title('Psychometric Function for Color');
ylabel('Proportion Rightward Choice');
xlabel('Coherence');
x = [0,1];
y = [.5,.5];
line(x,y, 'Color','Black','LineStyle','-');
line(y,x, 'Color','Black','LineStyle','-');
hold off;

%-----------------------------------------------------------------------%
%% 
%Plot color accuracy as a function of time over the course of the year?
%Already made colordatamatrix and accVector

%Make unixtime vector
timeVector = colordatamatrix(:,19);


averageacc = [];
increment = 600000; %10 minutes
starttime = timeVector(1);
endtime = timeVector(1) + increment;
bins = starttime;
tempVector = []; 

while endtime < timeVector(length(timeVector))
    
    for i=1:length(timeVector)
        if timeVector(i) > starttime && timeVector(i) < endtime
            tempVector = [tempVector, accVector(i)];
        end 
    end
    
    if length(tempVector) > 10
        averageacc = [averageacc, mean(tempVector)]
        bins = [bins, endtime];
    else 
        averageacc = [averageacc, NaN]
        bins = [bins, endtime];
    end
    
        
    starttime = endtime;
    endtime = starttime + increment;    
    tempVector = [];
end 

finalbins = datetime(bins/1000,'ConvertFrom','posixTime','TimeZone','America/New_York','Format','dd-MMM-yyyy HH:mm:ss.SSS');
finalbinsrow = finalbins.';
finalbinsrow = finalbinsrow(1:end-1);

subplot(2,2,3);
plot(finalbinsrow,averageacc,'Color', 'bl');
title('Performance Over the Course of the Day');
ylabel('Accuracy (10 Minute Increments)');
xlabel('Time');
%-----------------------------------------------------------------------%
%% 
%Plot accuracy as a function of dot duration

accVector = colordatamatrix(:,14);
dotdurationVector = colordatamatrix(:,10);
%hist(dotdurationVector);
dotdurationList = unique(dotdurationVector);

edges = dotdurationList(1:20:end);
means = zeros(length(edges),1);
binaccuracy = [];
lines = [];

subplot(2,2,4);
title('Accuracy vs. Dot Duration (For All Coherences)');
ylabel('Accuracy');
xlabel('Dot Duration (ms)');
for x=1:length(cohList)
    for j=1:length(edges)-1
        for i=1:length(dotdurationVector)
            if (dotdurationVector(i) > edges(j) && dotdurationVector(i) < edges(j+1) && cohVector(i) == cohList(x)) %what if =
                binaccuracy = [binaccuracy, accVector(i)];
            end
        end
        means(j) = mean(binaccuracy);
        binaccuracy = [];

    end
    means = means(1:end-1);
    edges = edges(1:end-1);
    hold on;
    plot(edges,means);
    text(max(edges),max(means),num2str(cohList(x)));
end 


hold off;
    
%-----------------------------------------------------------------------%
%%
goRTVector = colordatamatrix(:,15);
accVector = colordatamatrix(:,14);
responseVector = colordatamatrix(:,13);

% parse out the correct choices from accuracy vector 
correctChoicesGoRT = [];
meangoRTs = [];


for i=1:length(cohList)
    for j=1:length(accVector)
        if accVector(j) == 1 && cohVector(j) == cohList(i)
            correctChoicesGoRT = [correctChoicesGoRT, goRTVector(j)];
        end
    end 
    meangoRTs = [meangoRTs, mean(correctChoicesGoRT)];
    correctChoicesGoRT = [];
end 

subplot(2,2,2);

title('goRT vs. Coherence');
xlabel('Coherence');
ylabel('goRT');
hold on;
scatter (cohList(1:6),meangoRTs(1:6),'blue','filled');
scatter (cohList(7:12),meangoRTs(7:12),'yellow', 'filled');
hold off;
           
                
               
                
            
          




