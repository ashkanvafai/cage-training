clear variables 
close all


%location of the folder with color data
sDir = '/Users/ashkanvafai/Documents/Motion and Color/motion/';
fileList = dir(fullfile(sDir, '*.json')); 

%create matrix to store 23 data points each for n .json files. 
global motiondatamatrix;
motiondatamatrix = zeros(length(fileList),23); 

%loop through list of .json files and add to the datamatrix using columnCodes to reference relevant data. 
for i = 1:length(fileList)
    for j = 1:23
        
        filename = [sDir fileList(i,1).name];
        tempData = jsondecode(fileread(filename)); 
        columncode = gitcolumnCodes(j);
        
        if strcmp(tempData.(columncode), 'left') == 1
            motiondatamatrix(i,j) = 0;
        end
        
        if strcmp(tempData.(columncode), 'right') == 1
            motiondatamatrix(i,j) = 1;
        end
        
        if strcmp(tempData.(columncode), 'left') == 0 && strcmp(tempData.(columncode), 'right') == 0
            motiondatamatrix(i,j) = tempData.(columncode);
        end    
        
    end 
end        
 

%save this matrix to its own .mat file 
save('motiondatamatrix');
%load the matrix .mat file to a new script and perform calculations there.

