function write_node(sphereWidths,nscouts,scout_mni,scout_labels)
clear mydata2;
n=sphereWidths;
numLines = nscouts;
Pos=scout_mni.centroids.*1000;
Node=[Pos n n];
for k = 1:numLines
    for j=1:5
   mydata2(k,j) = string(Node(k,j));
    end
    mydata2(k,6)=string(scout_labels{k})
end
% mydata2=[mydata2 string(scout_labels)];
fileID = fopen('data/temp/NodeBNV.node','w');
fprintf(fileID,'%s %s %s %s %s %s\n',mydata2');
fclose(fileID);

