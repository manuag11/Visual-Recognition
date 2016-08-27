%This script generates test.txt that will serve as an input to the model
%for testing
load('filenames.mat');
fileID=fopen('test.txt','w');
for i=1:25
    s=classnames{i};
    s1=strsplit(s);
    s=s1{1};
    len=length(s);
    class_name=s(1:len-1);
    for j=1:20
        image_name=test1ImNames{i,j};
        ss1=strsplit(image_name,'/');
        len=size(ss1,2);
        image_name=ss1{len};
        fprintf(fileID,'/home/03701/manuag/hw2/data/test_images/%s/%s %d\n',class_name,image_name,i-1);
    end
end