function [motiondatamatrix] = gitmotionScript(filename)
%make array newColumnCodes filled with the 23 relevant codes from

sDir = filename;
fileList = dir(fullfile(sDir, '*.json')); 

%create matrix to store 23 data points each for n .json files. 
motiondatamatrix = nan(length(fileList),92); 
        
C = gitcolumnCodes_2D;

%loop through list of .json files and add to the datamatrix using columnCodes to reference relevant data. 
for i = 1:length(fileList)
    filename = [sDir fileList(i,1).name];
    temptempData = jsondecode(fileread(filename));
    tempData = temptempData(1,:); %grabs the first row in case we had a messed up file
    
        if strcmp(tempData.response,'left')
            motiondatamatrix(i,C.target_choice) = 0;
        elseif strcmp(tempData.response, 'right')
            motiondatamatrix(i,C.target_choice) = 1;
        end
                
        motiondatamatrix(i,C.isCorrect) = tempData.accuracy;
        
        motiondatamatrix(i,C.react_time) = tempData.goRT;
        
        motiondatamatrix(i,C.dot_duration) = tempData.dr_DotDuration;
        
        motiondatamatrix(i,C.react_time) = tempData.goRT;
        
        motiondatamatrix(i,C.reward_size) = tempData.juiceTime;

  
        if tempData.direction == 0
            motiondatamatrix(i,C.motionCoherence) = (tempData.coherence)*(-1);
        elseif tempData.direction == 1
            motiondatamatrix(i,C.motionCoherence) = (tempData.coherence);
        end
        
        motiondatamatrix(i,C.time_target1_on) = tempData.unixTime;

end
        
