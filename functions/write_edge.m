function write_edge(nscouts,e)


numLines = nscouts;
fid = fopen('data/temp/EdgeBNV.edge','wt');
for ii = 1:size(e,1)
    fprintf(fid,'%g\t',e(ii,:));
    fprintf(fid,'\n');
end
fclose(fid);