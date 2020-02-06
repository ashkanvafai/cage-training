function [glmstats] = gitmotiondataAnalysis(motiondatamatrix, name, day, task)
%clear variables 
%close all  

%save data file in datafolder, load data file here
%load('/Users/ashkanvafai/Desktop/Cage Training Data/Data Matrices/old dataset');
%load('/Users/ashkanvafai/Desktop/Cage Training Data/Data Matrices/Shimmy 20191205 motion');
%load('/Users/ashkanvafai/Desktop/Cage Training Data/Data Matrices/Shimmy motion glmstatsmatrix');


C = gitcolumnCodes_2D; 
hFig=figure('Position',[400 200 1200 600],'Name',char(strcat(name,day,task)));
colormap (hFig,winter); %Not working

%-----------------------------------------------------------------------%
%% 
%coherence vs. percent correct
cohVector = motiondatamatrix(:,C.motionCoherence);
accVector = motiondatamatrix(:,C.isCorrect);

cohList = unique(cohVector);

for i=1:length(cohList)
    meanvector1(i) = mean(accVector(cohVector==cohList(i)));
end


subplot(4,2,7);
plot(cohList,meanvector1, 'Color','r');
title('Accuracy vs. Motion Coherence');
ylabel('Accuracy');
xlabel('Coherence');
%-----------------------------------------------------------------------%
%%
dotdurationVector = motiondatamatrix(:,C.dot_duration);
cohVector = motiondatamatrix(:,C.motionCoherence);
choiceVector = motiondatamatrix(:,C.target_choice);
cohList = unique(cohVector);

highddchoices = [];
lowddchoices = [];
highddcohVector =[];
lowddcohVector =[];
for i=1:length(choiceVector)
    if (dotdurationVector(i)>900)
        highddchoices =[highddchoices,choiceVector(i)];
        highddcohVector = [highddcohVector, cohVector(i)];
    end 
    if (dotdurationVector(i)<450)
        lowddchoices =[lowddchoices,choiceVector(i)];
        lowddcohVector = [lowddcohVector, cohVector(i)];
    end 
end 

highddmeanVector = [];
for i=1:length(cohList)
    highddmeanVector(i) = mean(highddchoices(highddcohVector==cohList(i)))
end

highddmeanVectors = highddmeanVector';
highddglmstats = glmfit(cohList,highddmeanVectors,'binomial');

lowddmeanVector = [];
for i=1:length(cohList)
    lowddmeanVector(i) = mean(lowddchoices(lowddcohVector==cohList(i)))
end

lowddmeanVectors = lowddmeanVector';
lowddglmstats = glmfit(cohList,lowddmeanVectors,'binomial');
%glmstatsmatrix = glmstats;%just run this line to initialize 
%glmstatsmatrix = horzcat(glmstatsmatrix,glmstats);%just run this line for
%subsequent additions to the matrix

%using all dd values
meanVector = [];
for i=1:length(cohList)
    meanVector(i) = mean(choiceVector(cohVector==cohList(i)))
end

meanVectors = meanVector';
glmstats = glmfit(cohList,meanVectors,'binomial');



highddyfit(:,1) = glmval(highddglmstats(:,1),cohList(:,1), 'logit');
lowddyfit(:,1) = glmval(lowddglmstats(:,1),cohList(:,1), 'logit');
subplot(4,2,1);
hold on 
scatter(cohList,highddmeanVector);
scatter(cohList,lowddmeanVector);
plot(cohList, highddyfit, 'Color','b');
    text(max(cohList),max(highddyfit),'high dot durations','Color','b');
plot(cohList, lowddyfit, 'Color','r','LineStyle','--');
    text(max(cohList),max(lowddyfit),'low dot durations','Color','r');
title('Psychometric Function for Motion');
ylabel('Proportion Rightward Choice'); %check which one is on right
xlabel('Coherence');
%horizontal line
x = [-1,1];
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
%Already made motiondatamatrix and accVector

%Make unixtime vector
timeVector = motiondatamatrix(:,C.time_target1_on);


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

set(0,'CurrentFigure',hFig);
subplot(4,2,3);
plot(finalbinsrow,averageacc,'Color', 'bl');
title('Performance Over the Course of the Day');
ylabel('Accuracy (10 Minute Increments)');
xlabel('Time');
%-----------------------------------------------------------------------%
%% 
%Plot accuracy as a function of dot duration

dotdurationVector = motiondatamatrix(:,C.dot_duration);
dotdurationList = unique(dotdurationVector);

edges = dotdurationList(1:100:end);
means = zeros(length(edges),1);
binaccuracy = [];
lines = [];
highcohList = [cohList(1),cohList(2),cohList(length(cohList)-1),cohList(length(cohList))];

subplot(4,2,4);
title('Accuracy vs. Dot Duration (For High Coherences)');
ylabel('Accuracy');
xlabel('Dot Duration (ms)');
for x=1:length(highcohList)
    for j=1:length(edges)-1
        for i=1:length(dotdurationVector)
            if (dotdurationVector(i) > edges(j) && dotdurationVector(i) < edges(j+1) && (cohVector(i)) == highcohList(x)) %what if =
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
    text(max(edges),max(means),num2str(highcohList(x)));
end 

hold off;
%-----------------------------------------------------------------------%
%%    
%plot distribution of dot durations 

durationDistVector  = [];

set(0,'CurrentFigure',hFig);
subplot(4,2,6);

for i=1:length(dotdurationList)-1
    counter = 0;
    for j=1:length(dotdurationVector)
        if (dotdurationVector(j) == dotdurationList(i))
            counter = counter+1;
        end
    end
    durationDistVector(i) = counter;
end 

%histogram('BinEdges',dotdurationList,'BinCounts',durationDistVector)
%histogram(durationDistVector,dotdurationList);
hold on;
histogram(durationDistVector,'Orientation', 'vertical');
title('Dot Duration Distribution');
xlabel('Representative Range of Dot Duration');
ylabel('Frequency of Occurence');
hold off;
%-----------------------------------------------------------------------%
%%
goRTVector = motiondatamatrix(:,C.react_time);
responseVector = motiondatamatrix(:,C.target_choice);

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

set(0,'CurrentFigure',hFig);
subplot(4,2,2);

title('goRT vs. Coherence');
xlabel('Coherence');
ylabel('goRT');
hold on;
mid = round(((length(cohList))/2));
last = length(cohList);
scatter (cohList(1:mid),meangoRTs(1:mid),'blue','filled');%handle this
scatter (cohList((mid+1):last),meangoRTs((mid+1):last),'red', 'filled');
hold off;
%-----------------------------------------------------------------------%
%%
highddRT = [];
highdd = [];

for i=1:length(dotdurationVector)
    if (dotdurationVector(i)>900)  && (cohVector(i)>.46 || cohVector(i)<-.46)
        highdd = [highdd,dotdurationVector(i)];
        highddRT = [highddRT, goRTVector(i)];
    end
end

uniquehighdd = unique(highdd);
temphighddRT = [];
meanhighddRT =[];

for i=1:length(uniquehighdd)
   for j=1:length(highdd)
        if highdd(j)==uniquehighdd(i)
            temphighddRT = [temphighddRT,highddRT(i)];
            %meanhighddRT(i) = mean(highddRT(highdd==uniquehighdd(i)));
        end 
   end 
   meanhighddRT = [meanhighddRT,mean(temphighddRT)];
   temphighddRT = [];
end

subplot(4,2,5);
xlabel('High dot durations');
ylabel('goRT');
hold on;
scatter(uniquehighdd,meanhighddRT);
hold off;
%-----------------------------------------------------------------------%
%%
%save('/Users/ashkanvafai/Desktop/Cage Training Data/Data Matrices/Shimmy motion glmstatsmatrix','glmstatsmatrix');

         
               
                
            
          




