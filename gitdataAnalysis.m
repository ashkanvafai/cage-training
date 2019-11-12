%clear variables 
%close all  

%save data file in datafolder, load data file here
load('/Users/ashkanvafai/Documents/Motion and Color/Data Matrix');
C = gitcolumnCodes_2D; 

%-----------------------------------------------------------------------%
%% 
%coherence vs. percent correct
cohVector = colordatamatrix(:,C.colorCoherence);
accVector = colordatamatrix(:,C.isCorrect);

cohList = unique(cohVector);

for i=1:length(cohList)
    meanvector1(i) = mean(accVector(cohVector==cohList(i)));
end


%subplot(2,2,2);
plot(cohList,meanvector1, 'Color','r');
title('Accuracy vs. Coherence');
ylabel('Accuracy');
xlabel('Coherence');
%-----------------------------------------------------------------------%
%%
cohVector = colordatamatrix(:,C.colorCoherence);
choiceVector = colordatamatrix(:,C.target_choice);
cohList = unique(cohVector);

meanVector = [];
for i=1:length(cohList)
    meanVector(i) = mean(choiceVector(cohVector==cohList(i)))
end

meanVectors = meanVector';
glmstats = glmfit(cohList,meanVectors,'binomial');
yfit(:,1) = glmval(glmstats(:,1),cohList(:,1), 'logit');

subplot(2,2,1);
hold on 
scatter(cohList,meanVector);
plot(cohList, yfit, 'Color','r');
title('Psychometric Function for Color');
ylabel('Proportion Rightward Choice');
xlabel('Coherence');
%horizontal line
x = [-0.5,0.5];
y = [.5,.5];
%vertical line
z = [0,0];
q = [1,0];
line(x,y, 'Color','Black','LineStyle','-');
line(z,q, 'Color','Black','LineStyle','-');
hold off;

%-----------------------------------------------------------------------%
%% 
%Plot color accuracy as a function of time over the course of the year?
%Already made colordatamatrix and accVector

%Make unixtime vector
timeVector = colordatamatrix(:,C.time_target1_on);


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

dotdurationVector = colordatamatrix(:,C.dot_duration);
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
goRTVector = colordatamatrix(:,C.react_time);
responseVector = colordatamatrix(:,C.target_choice);

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
           
                
               
                
            
          




