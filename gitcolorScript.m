clear variables 
close all

%make array newColumnCodes filled with the 23 relevant codes from
%columnCodes_2D

%location of the folder with color data
sDir = '/Users/ashkanvafai/Documents/Motion and Color/color/';
fileList = dir(fullfile(sDir, '*.json')); 

%create matrix to store 23 data points each for n .json files. 
global colordatamatrix;
colordatamatrix = zeros(length(fileList),23); 

%loop through list of .json files and add to the datamatrix using columnCodes to reference relevant data. 
for i = 1:length(fileList)
    for j = 1:23
        
        filename = [sDir fileList(i,1).name];
        tempData = jsondecode(fileread(filename)); 
        columncode = gitcolumnCodes(j);

        if strcmp(tempData.(columncode), 'down') == 1
            colordatamatrix(i,j) = 0;
        end
        
        if strcmp(tempData.(columncode), 'up') == 1
            colordatamatrix(i,j) = 1;
        end
        
        if strcmp(tempData.(columncode), 'up') == 0 && strcmp(tempData.(columncode), 'down') == 0
            colordatamatrix(i,j) = tempData.(columncode);
        end    
        
    end 
end        
 

%save this matrix to its own .mat file 
save('colordatamatrix');
%load the matrix .mat file to a new script and perform calculations there.

