%This script is to copy test images from cs machines to local
load('filenames.mat');
fileID=fopen('exp_test.txt','w');
for i=1:25
    s=classnames{i};
    s1=strsplit(s);
    s=s1{1};
    len=length(s);
    class_name=s(1:len-1);
    fprintf(fileID,'mkdir -p ./Desktop/test_images/%s\n',class_name);
    for j=1:20
        fprintf(fileID,'scp manuag@aero.cs.utexas.edu:%s ./Desktop/test_images/%s\n',test1ImNames{i,j},class_name);
    end
end