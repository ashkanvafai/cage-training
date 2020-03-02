function [colordatamatrix] = gitcolorScript(filename)

sDir = filename;
fileList = dir(fullfile(filename, '*.json')); 

%create matrix to store 23 data points each for n .json files. 
colordatamatrix = nan(length(fileList),92); 
        
C = gitcolumnCodes_2D;

%loop through list of .json files and add to the datamatrix using columnCodes to reference relevant data. 
for i = 1:length(fileList)
    filename = [sDir fileList(i,1).name];
    temptempData = jsondecode(fileread(filename));
    tempData = temptempData(1,:); %grabs the first row in case we had a messed up file
    
    if tempData.goRT < 1500
    
        if strcmp(tempData.response,'down')
            colordatamatrix(i,C.target_choice) = 0;
        elseif strcmp(tempData.response, 'up')
            colordatamatrix(i,C.target_choice) = 1;
        end
                
        colordatamatrix(i,C.isCorrect) = tempData.accuracy;
                
        colordatamatrix(i,C.dot_duration) = tempData.dr_DotDuration;
        
        colordatamatrix(i,C.react_time) = tempData.goRT;
  
        if tempData.direction == 0
            colordatamatrix(i,C.colorCoherence) = (0.5 - tempData.coherence);
        elseif tempData.direction == 1
            colordatamatrix(i,C.colorCoherence) = (tempData.coherence - 0.5);
        end
        
        colordatamatrix(i,C.time_target1_on) = tempData.unixTime;
    end 
    
end
        



%save this matrix to its own .mat file 
%save('/Users/ashkanvafai/Desktop/Cage Training Data/Data Matrices/Bo 20200121 color','colordatamatrix');
%load the matrix .mat file to a new script and perform calculations there.

