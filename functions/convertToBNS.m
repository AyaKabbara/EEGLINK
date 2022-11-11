for i=1:210
    coordSCS(i,:,:,:)=Vertices(Scouts(i).Seed,:,:,:);
end

P_mni = cs_convert(sMri, 'scs', 'mni', coordSCS);       % SCS   => MNI coordinates

for i=1:210
    orient(i,:,:,:)=HeadModel.GridOrient(Scouts(i).Seed,:,:,:);
end

