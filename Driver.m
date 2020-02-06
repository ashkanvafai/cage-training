clear variables; 
close all;  

% name = 'Bo'; dates = {'20191122','20191125','20200121'}; task = 'color';
% name = 'Shimmy'; dates = {'20191125','20191205','20200121'}; task = 'motion';

glmstatsmatrix = [];


for i=1:length(dates)
    
    filename = char(strcat('/Users/ashkanvafai/Desktop/Cage Training Data/',name,'/',dates(i),'/',task,'/'));
    
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



