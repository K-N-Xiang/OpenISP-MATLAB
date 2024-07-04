function [Raw]=reconstruct_Raw(SubRaw)
    [W,H,~]=size(SubRaw);
    Raw=zeros([2*W 2*H]);
    for i=1:W
        for j=1:H
            Raw(2*i-1,2*j-1)=SubRaw(i,j,1);
            Raw(2*i-1,2*j)=SubRaw(i,j,2);
            Raw(2*i,2*j-1)=SubRaw(i,j,3);
            Raw(2*i,2*j)=SubRaw(i,j,4);
        end
    end
end