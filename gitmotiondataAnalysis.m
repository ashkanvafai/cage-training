function [glmstats] = gitmotiondataAnalysis(motiondatamatrix, name, day, task)
C = gitcolumnCodes_2D; 
hFig=figure('Position',[400 200 1200 600],'Name',char(strcat(name,day,task)));
set(hFig,'visible','off');
%-----------------------------------------------------------------------%
% %% how often are they rewarded after correct responses
% tFig=figure('Position',[400 200 1200
% 600],'Name',char(strcat(name,day,task))); set(0,'CurrentFigure',tFig)
% juiceTime = motiondatamatrix(:,C.reward_size); accVector =
% motiondatamatrix(:,C.isCorrect); cohVector =
% motiondatamatrix(:,C.motionCoherence);
% 
% count = []; juiceforcorrect = []; for i=1:length(cohVector)
%     if (accVector(i)==1)
%         juiceforcorrect = horzcat(juiceforcorrect,juiceTime(i)); count =
%         horzcat(count,i);
%     end
% end x = count; y = length(juiceforcorrect); subplot(1,1,1);
% scatter(count,juiceforcorrect);
%-----------------------------------------------------------------------%
%% 
%coherence vs. percent correct
cohVector = motiondatamatrix(:,C.motionCoherence);
accVector = motiondatamatrix(:,C.isCorrect);
cohList = unique(cohVector);
meanaccvector = [];


for i=1:length(cohList)
    for j=1:length(cohVector)
        meanaccvector(i) = mean(accVector(cohVector==cohList(i)));
    end
end 

hold on;
set(0,'CurrentFigure',hFig);
subplot(3,2,2);
plot(cohList,meanaccvector, 'Color','r');
title('Accuracy vs. Motion Coherence');
ylabel('Accuracy');
xlabel('Coherence');
hold off;
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

%using all dd values
meanVector = [];
for i=1:length(cohList)
    meanVector(i) = mean(choiceVector(cohVector==cohList(i)));
end

meanVectors = meanVector';
glmstats = glmfit(cohList,meanVectors,'binomial');


allddyfit(:,1) = glmval(glmstats(:,1),cohList(:,1), 'logit');
highddyfit(:,1) = glmval(highddglmstats(:,1),cohList(:,1), 'logit');
lowddyfit(:,1) = glmval(lowddglmstats(:,1),cohList(:,1), 'logit');


hold on;
set(0,'CurrentFigure',hFig);
subplot(3,2,1);
title(char(strcat('Psychometric Function for -',name,day,task)));
ylabel('Proportion Rightward Choice'); 
xlabel('Coherence');
hold off;

hold on;
scatter(cohList,meanVector);
plot(cohList, allddyfit, 'Color','black');
    text(max(cohList),max(allddyfit),'all dot durations','Color','black');
hold off;

hold on;
scatter(cohList,highddmeanVector);
plot(cohList, highddyfit, 'Color','b','LineStyle','--');
    text(max(cohList),max(highddyfit),'high dot durations','Color','b');
hold off;

hold on;
scatter(cohList,lowddmeanVector);
plot(cohList, lowddyfit, 'Color','r','LineStyle','--');
    text(max(cohList),max(lowddyfit),'low dot durations','Color','r');
hold off;

hold on;
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
%Plot accuracy over the course of the day

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

hold on;
set(0,'CurrentFigure',hFig);
subplot(3,2,3);
plot(finalbinsrow,averageacc,'Color', 'bl');
title('Performance Over the Course of the Day');
ylabel('Accuracy (10 Minute Increments)');
xlabel('Time');
hold off;
%-----------------------------------------------------------------------%
%% 
%Plot accuracy as a function of dot duration

dotdurationVector = motiondatamatrix(:,C.dot_duration);
dotdurationList = unique(dotdurationVector);

edges = dotdurationList(1:100:end);
means = zeros(length(edges),1);
binaccuracy = [];
highcohList = [];

if length(cohList)>6
    highcohList = [cohList(1),cohList(2),cohList(length(cohList)-1),cohList(length(cohList))];
end 
if length(cohList)<6
    highcohList = cohList;
end 

hold on;
set(0,'CurrentFigure',hFig);
subplot(3,2,4);
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

for i=1:length(dotdurationList)-1
    counter = 0;
    for j=1:length(dotdurationVector)
        if (dotdurationVector(j) == dotdurationList(i))
            counter = counter+1;
        end
    end
    durationDistVector(i) = counter;
end 

dotdurationListT = dotdurationList';


hold on;
set(0,'CurrentFigure',hFig);
subplot(3,2,6);
histogram('BinEdges',dotdurationListT,'BinCounts',durationDistVector)
title('Dot Duration Distribution');
ylabel('Frequency');
xlabel('Dot Duration');
hold off;
%-----------------------------------------------------------------------%
%%
goRTVector = motiondatamatrix(:,C.react_time);

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

hold on;
set(0,'CurrentFigure',hFig);
subplot(3,2,5);
title('goRT vs. Coherence');
xlabel('Coherence');
ylabel('goRT');
hold off;
mid = round(((length(cohList))/2));
last = length(cohList);

hold on;
scatter (cohList(1:mid),meangoRTs(1:mid),'blue','filled');%handle this
hold off;

hold on;
scatter (cohList((mid+1):last),meangoRTs((mid+1):last),'red', 'filled');
hold off;
%-----------------------------------------------------------------------%
%%
saveas(hFig, char(strcat('/Users/ashkanvafai/Desktop/Cage Training Data/',name,' Figures/Single Days/',name,day,task,'.png')));


         
               
                
            
          




