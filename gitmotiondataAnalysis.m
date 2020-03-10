function [glmstats] = gitmotiondataAnalysis(motiondatamatrix, name, day, task)
C = gitcolumnCodes_2D; 
hFig=figure('Position',[400 200 1200 600],'Name',char(strcat(name,day,task)));
set(hFig,'visible','off');
%-----------------------------------------------------------------------%
%positions of subplots
posInfo = [.02 .8 .1 .15];
posDotDist = [.14 .8 .1 .2];
posCourseOfDay = [.045 .1 .2 .55];

posGoRT = [.35 .1 .3 .35];
posPsychometric = [.35 .6 .3 .35];
posAnnotation1 = [.36 .79 .1 .15];
posAnnotation2 = [.36 .75 .1 .15];

posAccDD = [.77 .1 .15 .55];
posAccCoh = [.77 .8 .2 .2];

%-----------------------------------------------------------------------%
%%
%Information about Day
hold on;
subplot('Position',posInfo);
set(gca,'XColor', 'none','YColor','none');
info = annotation('textbox',posInfo,'String',{['Monkey: ',char(name)],['Date: ',char(day)],['Task: ', char(task)],['Trials: ',char(num2str(size(colordatamatrix,1)))]},'Color','Black','EdgeColor', 'none','FontSize',12);
hold off;
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
%subplot(3,2,2);
subplot('Position',posAccCoh);
plot(cohList,meanaccvector, 'Color','r');
title('Accuracy vs. Coherence');
ylabel('% Correct');
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
    if (dotdurationVector(i)>600)
        highddchoices =[highddchoices,choiceVector(i)];
        highddcohVector = [highddcohVector, cohVector(i)];
    end 
    if (dotdurationVector(i)<600)
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

cohSpectrum = (-1:0.1:1)';
highddyfit(:,1) = glmval(highddglmstats(:,1),cohSpectrum, 'logit');
lowddyfit(:,1) = glmval(lowddglmstats(:,1),cohSpectrum, 'logit');

hold on;
str1 = ['b0: ', num2str(highddglmstats(1,1))];
str2 = ['b1: ', num2str(highddglmstats(2,1))];
str3 = ['b0: ', num2str(lowddglmstats(1,1))];
str4 = ['b1: ', num2str(lowddglmstats(2,1))];

Annotation1 = annotation('textbox',posAnnotation1 ,'String',{'Dot Duration > 652 ms',str1,str2},'Color','b','EdgeColor', 'none','FontSize',8);
Annotation2 = annotation('textbox',posAnnotation2 ,'String',{'Dot Duration < 652 ms',str3,str4},'Color','r','EdgeColor', 'none','FontSize',8);
hold off;


hold on;
set(0,'CurrentFigure',hFig);
%subplot(3,2,1);
subplot('Position',posPsychometric);
title(char(strcat('Choices - Split by Dot Duration')));
ylabel('Proportion Rightward Choice'); 
xlabel('Coherence');
hold off;

hold on;
scatter(cohList,highddmeanVector);
plot(cohSpectrum, highddyfit, 'Color','b','LineStyle','--');
    %text(max(cohList),max(highddyfit),'high dot durations','Color','b');
hold off;

hold on;
scatter(cohList,lowddmeanVector);
plot(cohSpectrum, lowddyfit, 'Color','r','LineStyle','--');
    %text(max(cohList),max(lowddyfit),'low dot durations','Color','r');
hold off;

hold on;
%horizontal line
x = [-1,1];
y = [.5,.5];
%vertical line
z = [0,0];
q = [1,0];

line(z,q, 'Color','Black','LineStyle','-');
line(x,y, 'Color','Black','LineStyle','-');
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
finalbinsrow = finalbins';
finalbinsrow = finalbinsrow(1:end-1);
finalbinsrownum = datenum(finalbinsrow);

hold on;
set(0,'CurrentFigure',hFig);
%subplot(3,2,3);
subplot('Position',posCourseOfDay);
plot(finalbinsrownum,averageacc,'Color', 'bl');
title('% Correct Over Course of Day');
ylabel('Accuracy (10 Minute Increments)');
xlabel('Time');
%xticks(finalbinsrownum(1),finalbinsrownum(length(finalbinsrownum)/2), finalbinsrownum(length(finalbinsrownum)));
%xticklabels(datestr(finalbinsrow(1),datestr(finalbinsrow(length(finalbinsrow)/2),datestr(finalbinsrow(length(finalbinsrow))))));
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
%subplot(3,2,4);
subplot('Position',posAccDD);
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
    set(0,'CurrentFigure',hFig);
subplot('Position',posAccDD);
ylim([0,1]);
title({'Accuracy vs. Dot Duration (Highest 4 Coherences)',''});
ylabel('Accuracy');
xlabel('Dot Duration (ms)');
for x=1:length(highcohList)
    for j=1:length(edges)-1
        for i=1:length(dotdurationVector)
            if ((dotdurationVector(i) > edges(j) ||dotdurationVector(i) == edges(j)) && dotdurationVector(i) < edges(j+1) && (cohVector(i)) == highcohList(x)) %what if =
                binaccuracy = [binaccuracy, accVector(i)];
            end
        end
        means(j) = mean(binaccuracy);
        binaccuracy = [];
    end
    means = means(1:end-1);
    edges = edges(1:end-1);
    
    hold on;
    colors = ['r','b','k','m'];
    
    plot(edges,means,'Color',colors(x));
        label = text(max(edges),max(means),num2str(highcohList(x)));
        if mod(x,2) == 1
            if ~isempty(label)
                label.Color = colors(x);
                label.HorizontalAlignment = 'left';
                label.FontWeight = 'bold';
            end
        end 
        if mod(x,2) == 0
            if ~isempty(label)
                label.Color = colors(x);
                label.HorizontalAlignment = 'right';
                label.FontWeight = 'bold';
            end
        end 
        
    means = zeros(length(edges),1);
end 

hold off;
%-----------------------------------------------------------------------%
%%    
%plot distribution of dot durations 
durationDistVector  = [];
index=isnan(dotdurationList);
dotdurationList(index) = [];

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
%subplot(3,2,6);
subplot('Position',posDotDist);
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
%subplot(3,2,5);
subplot('Position',posGoRT);
title('goRT vs. Coherence');
xlabel('Go RT for Correct Trials');
ylabel('goRT');
hold off;

poscoh = [];
negcoh = [];
poscohRT = [];
negcohRT = [];
zerocohRT = [];

for i=1:length(cohList)
   
    if cohList(i)<0
        negcoh = [negcoh, cohList(i)];
        negcohRT = [negcohRT,meangoRTs(i)];
    end
    
    if cohList(i)>0
        poscoh = [poscoh, cohList(i)];
        poscohRT = [poscohRT,meangoRTs(i)];
    end
    
    if cohList(i)==0
        zerocohRT = meangoRTs(i);
    end
end 
    

hold on;
z = [0,0];
q = [0,max(meangoRTs)+100];
line(z,q, 'Color','Black','LineStyle','-');
hold off;

hold on;
scatter (negcoh, negcohRT,'blue','filled');
hold off;

hold on;
scatter (poscoh,poscohRT,'red', 'filled');
hold off;

hold on;
if length(zerocohRT)==1
    scatter (0,zerocohRT,'black', 'filled');
end
hold off;

%-----------------------------------------------------------------------%
%%
saveas(hFig, char(strcat('/Users/ashkanvafai/Desktop/Cage Training Data/',name,' Figures/Single Days/',name,day,task,'.png')));


         
               
                
            
          




