clear variables 
close all

%make array newColumnCodes filled with the 23 relevant codes from
%columnCodes_2D

%location of the folder with color data
sDir = '/Users/ashkanvafai/Documents/Motion and Color/color/';
%sDir = '/Users/Danique/Documents/Cage training/20190131/color/';
fileList = dir(fullfile(sDir, '*.json')); 

%create matrix to store 23 data points each for n .json files. 
%global colordatamatrix;
colordatamatrix = nan(length(fileList),92); 
        
C = gitcolumnCodes_2D;

%loop through list of .json files and add to the datamatrix using columnCodes to reference relevant data. 
for i = 1:length(fileList)
    filename = [sDir fileList(i,1).name];
    tempData = jsondecode(fileread(filename));
    
        if strcmp(tempData.response,'down')
            colordatamatrix(i,C.target_choice) = 0;
        elseif strcmp(tempData.response, 'up')
            colordatamatrix(i,C.target_choice) = 1;
        end
                
        colordatamatrix(i,C.isCorrect) = tempData.accuracy;
        
        colordatamatrix(i,C.react_time) = tempData.goRT;
        
        colordatamatrix(i,C.dot_duration) = tempData.dr_DotDuration;
        
        colordatamatrix(i,C.react_time) = tempData.goRT;
  
        if tempData.direction == 0
            colordatamatrix(i,C.colorCoherence) = (0.5 - tempData.coherence);
        elseif tempData.direction == 1
            colordatamatrix(i,C.colorCoherence) = (tempData.coherence - 0.5);
        end
        
        colordatamatrix(i,C.time_target1_on) = tempData.unixTime;

end
        



%save this matrix to its own .mat file 
save('/Users/ashkanvafai/Documents/Motion and Color/Data Matrix','colordatamatrix');
%load the matrix .mat file to a new script and perform calculations there.

