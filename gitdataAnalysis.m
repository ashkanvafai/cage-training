function [glmstats] = gitdataAnalysis(datamatrix, name, day, task)
C = gitcolumnCodes_2D; 
hFig=figure('Position',[400 200 1200 600],'Name',char(strcat(name,day,task)));
set(hFig,'visible','off');

%-----------------------------------------------------------------------%
%%
%positions of subplots
posInfo = [.02 .8 .1 .15];
posDotDist = [.14 .8 .1 .15];
posCourseOfDay = [.045 .1 .2 .55];

posGoRT = [.35 .1 .3 .35];
posPsychometric = [.35 .6 .3 .35];
posAnnotation1 = [.36 .79 .1 .15];
posAnnotation2 = [.36 .75 .1 .15];

posAccDD = [.77 .1 .15 .55];
posAccCoh = [.77 .8 .18 .15];
%-----------------------------------------------------------------------%
%% 
%Information about Day
hold on;
subplot('Position',posInfo);
set(gca,'XColor', 'none','YColor','none');
info = annotation('textbox',posInfo,'String',{['Monkey: ',char(name)],['Date: ',char(day)],['Task: ', char(task)], ['Trials: ',char(num2str(size(datamatrix,1)))]},'Color','Black','EdgeColor', 'none','FontSize',12);
hold off;
%-----------------------------------------------------------------------%
%%
%Accuracy
if strcmp(task,'color')
    cohVector = datamatrix(:,C.colorCoherence);
end
if strcmp(task,'motion')
    cohVector = datamatrix(:,C.motionCoherence);
end

accVector = datamatrix(:,C.isCorrect);
cohList = unique(cohVector);
meanaccvector = [];

for i=1:length(cohList)
    meanaccvector(i) = mean(accVector(cohVector==cohList(i)));
end

hold on;
set(0,'CurrentFigure',hFig)
subplot('Position',posAccCoh);
ylim([0,1]);
xlim([-1,1]);

plot(cohList,meanaccvector, 'Color','black');
title('Accuracy');
ylabel('% Correct');
xlabel('Coherence');
hold off;
%-----------------------------------------------------------------------%
%%
%Psychometric Function
dotdurationVector = datamatrix(:,C.dot_duration);
choiceVector = datamatrix(:,C.target_choice);
cohList = unique(cohVector);

highddchoices = [];
lowddchoices = [];
highddcohVector =[];
lowddcohVector =[];

threshold = median(dotdurationVector(1,:));

for i=1:length(choiceVector)
    if (dotdurationVector(i)>threshold)
        highddchoices =[highddchoices,choiceVector(i)];
        highddcohVector = [highddcohVector, cohVector(i)];
    end 
    if (dotdurationVector(i)<threshold)
        lowddchoices =[lowddchoices,choiceVector(i)];
        lowddcohVector = [lowddcohVector, cohVector(i)];
    end 
end 

highddmeanVector = [];
for i=1:length(cohList)
    highddmeanVector(i) = mean(highddchoices(highddcohVector==cohList(i)));
end

highddmeanVectors = highddmeanVector';
highddglmstats = glmfit(cohList,highddmeanVectors,'binomial');

lowddmeanVector = [];
for i=1:length(cohList)
    lowddmeanVector(i) = mean(lowddchoices(lowddcohVector==cohList(i)));
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


cohSpectrum = linspace(min(cohList),max(cohList))';                   % Evenly-Spaced Interpolation Vector

allddyfit(:,1) = glmval(glmstats(:,1),cohSpectrum, 'logit');
highddyfit(:,1) = glmval(highddglmstats(:,1),cohSpectrum, 'logit');
lowddyfit(:,1) = glmval(lowddglmstats(:,1),cohSpectrum, 'logit');

hold on;
str1 = ['b0: ', num2str(highddglmstats(1,1))];
str2 = ['b1: ', num2str(highddglmstats(2,1))];
str3 = ['b0: ', num2str(lowddglmstats(1,1))];
str4 = ['b1: ', num2str(lowddglmstats(2,1))];

threshold = num2str(threshold);
h = annotation('textbox',posAnnotation1,'String',{['Dot Duration > ',threshold],str1,str2},'Color','r','EdgeColor', 'none','FontSize',6);
l = annotation('textbox',posAnnotation2,'String',{['Dot Duration < ',threshold],str3,str4},'Color','b','EdgeColor', 'none','FontSize',6);
hold off;


hold on;
set(0,'CurrentFigure',hFig)
subplot('Position',posPsychometric);
xlim([min(cohList)-.1,max(cohList)+.1]);
ylim([0,1]);
title(char(strcat('Choices - Split by Dot Duration')));
if strcmp(task,'color')
    ylabel('Proportion Upward Choice'); 
end 
if strcmp(task,'motion')
    ylabel('Proportion Rightward Choice'); 
end 
xlabel('Coherence');
hold off;

% hold on;
% scatter(cohList,meanVector,'black');
% plot(cohSpectrum, allddyfit , 'Color','black');
% hold off;

hold on;
scatter(cohList,highddmeanVector,'b');
plot(cohSpectrum, highddyfit, 'Color','b');
     %text(max(cohList),max(highddyfit),'high dot durations','Color','b');
hold off;
 
hold on;
scatter(cohList,lowddmeanVector,'r');
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
line(x,y, 'Color','Black','LineStyle','-');
line(z,q, 'Color','Black','LineStyle','-');
hold off;
%-----------------------------------------------------------------------%
%% 
%Plot accuracy over the course of the day

%Make unixtime vector
timeVector = datamatrix(:,C.time_target1_on);


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
subplot('Position',posCourseOfDay);
ylim([0,1]);
plot(finalbinsrow,averageacc,'Color', 'black');
title('% Correct Over Course of Day');
ylabel('Accuracy (10 Minute Increments)');
xlabel('Time');
hold off;
%-----------------------------------------------------------------------%
%% 
%Plot accuracy as a function of dot duration

dotdurationVector = datamatrix(:,C.dot_duration);
dotdurationList = unique(dotdurationVector);

nanddList = isnan(dotdurationList);
dotdurationList(nanddList) = [];
divs = divisors(length(dotdurationList));
%increment = divs(1,end-2);
increment = 70;
edges = dotdurationList(1:increment:end);
lastedge = max(dotdurationList);
edges = [edges;lastedge];


means = zeros(length(edges),1);
binaccuracy = [];
highcohList = [];


nancohList=isnan(cohList);
cohList(nancohList) = [];

% if length(cohList)>6 || length(cohList) == 6
%     highcohList = [cohList(1),cohList(2),cohList(length(cohList)-1),cohList(length(cohList))];
% end 
% if length(cohList)<6  
%     highcohList = cohList;
% end 

hold on;
set(0,'CurrentFigure',hFig);
subplot('Position',posAccDD);
ylim([0,1]);
title({'Accuracy as a Function of Dot Duration - Split by Coherence',''});
ylabel('Accuracy');
xlabel('Dot Duration (ms)');
for x=1:length(cohList)
    for j=1:length(edges)-1
        for i=1:length(dotdurationVector)
            if ((dotdurationVector(i) > edges(j) ||dotdurationVector(i) == edges(j)) && dotdurationVector(i) < edges(j+1) && (cohVector(i)) == cohList(x)) %what if =
                binaccuracy = [binaccuracy, accVector(i)];
            end
        end
        means(j) = mean(binaccuracy);
        binaccuracy = [];
    end
    means = means(1:end-1);
    edges = edges(1:end-1);
    hold on;
    %colors = ['r','b','k','m',];
    
    plot(edges,means);%'Color',colors(x)
        %label = text(max(edges),max(means),num2str(cohList(x)));
        legend(num2str(cohList),'Location','southeast');
%         if mod(x,2) == 1
%            % if ~isempty(label)
%                 %label.Color = colors(x);
%                 %label.HorizontalAlignment = 'left';
%                 %label.FontWeight = 'bold';
%            % end
%         end 
%         if mod(x,2) == 0
%             if ~isempty(label)
%                 %label.Color = colors(x);
%                 %label.HorizontalAlignment = 'right';
%                 %label.FontWeight = 'bold';
%             end
%        end 
        
    means = zeros(length(edges),1);
end 

hold off;
%-----------------------------------------------------------------------%
%%    
%plot distribution of dot durations 
index=isnan(dotdurationList);
dotdurationList(index) = [];
durationDistVector  = [];

for i=1:length(dotdurationList)
    counter = 0;
    for j=1:length(dotdurationVector)
        if (dotdurationVector(j) == dotdurationList(i))
            counter = counter+1;
        end
    end
    durationDistVector(i) = counter;
end 

%create bins 
edges = dotdurationList(1:10:end);
columnlength = round(length(durationDistVector)/10);
m = vec2mat(durationDistVector,columnlength);
bincounts = mean(m);    

if length(edges) == length(bincounts)
    lastedge = max(edges)+1;
    edges = [edges;lastedge];
end
edgesT = edges';


hold on;
set(0,'CurrentFigure',hFig);
%subplot(3,2,6);
subplot('Position',posDotDist);
histogram('BinEdges',edgesT,'BinCounts',bincounts)
title('Dot Duration Distribution');
ylabel('Frequency');
xlabel('Dot Duration');
hold off;

%-----------------------------------------------------------------------%
%%
goRTVector = datamatrix(:,C.react_time);

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
subplot('Position',posGoRT);
xlim([min(cohList)-.1,max(cohList)+.1]);
title('Go RT for Correct Trials');
xlabel('Coherence');
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
scatter (negcoh, negcohRT,'black','filled');
hold off;

hold on;
scatter (poscoh,poscohRT,'black', 'filled');
hold off;

hold on;
if length(zerocohRT)==1
    scatter (0,zerocohRT,'black', 'filled');
end
hold off;

%-----------------------------------------------------------------------%
%%
saveas(hFig, char(strcat('/Users/ashkanvafai/Desktop/Cage Training Data/',name,' Figures/Single Days/',name,day,task,'.png')));


         
               
                
            
          




