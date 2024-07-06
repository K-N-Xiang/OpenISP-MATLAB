% Anti-aliasing Filter
function [AAFresult]=AAF(Raw)
    Raw=padarray(Raw,[2 2],'replicate');
    SubRaw=split_Raw(Raw,'nopadding');
    [W,H,C]=size(SubRaw);
    AAFSubRaw=zeros([W-2 H-2 C]);
    for k=1:C
        for i=2:W-1
            for j=2:H-1
                around_pixel = [SubRaw(i-1,j-1,k) SubRaw(i,j-1,k) SubRaw(i+1,j-1,k) SubRaw(i-1,j,k) SubRaw(i+1,j,k) SubRaw(i-1,j+1,k) SubRaw(i,j+1,k) SubRaw(i+1,j+1,k)];
                AAFSubRaw(i-1,j-1,k)=(8*SubRaw(i,j,k)+sum(around_pixel,'all'))/16;
            end
        end
    end
    AAFresult=reconstruct_Raw(AAFSubRaw);
end