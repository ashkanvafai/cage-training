clear variables; 
close all;  


name = 'Bo'; 
%name = 'Shimmy'; 

sDir = char(strcat('/Users/ashkanvafai/Desktop/Cage Training Data/',name));
tempdates = {};
fileList = dir(fullfile(sDir)); 
for i=1:length(fileList)
    tempdates(i) = {fileList(i).name}
end
dates = {};
counter = 1;
for i=1:length(tempdates)
    if contains(convertCharsToStrings(tempdates(i)),'20')
        dates(counter) = tempdates(i);
        counter = counter + 1;
    end
end

task = 'color';
%task = 'motion';

glmstatsmatrix = [];


for i=1:length(dates)
    
    filename = char(strcat(sDir,'/',dates(i),'/',task,'/'));
    
    if strcmp(task,'color')
        datamatrix = gitcolorScript(filename);
        glmstats = gitcolordataAnalysis(datamatrix, name, dates(i), task);
    end
    
    if strcmp(task,'motion')
        datamatrix = gitmotionScript(filename);
        glmstats = gitmotiondataAnalysis(datamatrix, name, dates(i), task);
    end
    
    glmstatsmatrix = horzcat(glmstatsmatrix,glmstats);
    
end 


if strcmp(task,'color')
    gitcolorsecondorderAnalysis(glmstatsmatrix, dates, name, task);
end

if strcmp(task,'motion')
    gitmotionsecondorderAnalysis(glmstatsmatrix, dates, name, task);
end



