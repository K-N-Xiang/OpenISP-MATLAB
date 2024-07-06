% Color Filter Array Interpolation (Demosaic)
function [CFAresult]=CFA(Raw)
    Raw=padarray(Raw,[2 2],'replicate');
    SubRaw=split_Raw(Raw,'padding');
    [W,H,~]=size(SubRaw);
    R=SubRaw(:,:,1);
    G=SubRaw(:,:,2)+SubRaw(:,:,3);
    B=SubRaw(:,:,4);
    %% R
    for i=2:(W/2-1)
        for j=2:(H/2-1)
            R(2*i-1,2*j)=(R(2*i-1,2*j-1)+R(2*i-1,2*j+1))/2;
            R(2*i,2*j-1)=(R(2*i-1,2*j-1)+R(2*i+1,2*j-1))/2;
            R(2*i,2*j)=(R(2*i-1,2*j-1)+R(2*i-1,2*j+1)+R(2*i+1,2*j-1)+R(2*i+1,2*j+1))/4;
        end
    end
    R=R(3:W-2,3:H-2);
    %% G
    for i=2:(W/2-1)
        for j=2:(H/2-1)
            G(2*i-1,2*j-1)=(G(2*i-1,2*j-2)+G(2*i-2,2*j-1)+G(2*i-1,2*j)+G(2*i,2*j-1))/4;
            G(2*i,2*j)=(G(2*i,2*j-1)+G(2*i-1,2*j)+G(2*i,2*j+1)+G(2*i+1,2*j))/4;
        end
    end
    G=G(3:W-2,3:H-2);
    %% B
    for i=2:(W/2-1)
        for j=2:(H/2-1)
            B(2*i-1,2*j-1)=(B(2*i-2,2*j-2)+B(2*i,2*j-2)+B(2*i-2,2*j)+B(2*i,2*j))/4;
            B(2*i-1,2*j)=(B(2*i-2,2*j)+B(2*i,2*j))/2;
            B(2*i,2*j-1)=(B(2*i,2*j-2)+B(2*i,2*j))/2;
        end
    end
    B=B(3:W-2,3:H-2);
    CFAresult=cat(3,R,G,B);
end