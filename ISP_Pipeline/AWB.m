% Auto White Balance
function [AWBresult]=AWB(Raw)
    SubRaw=split_Raw(Raw,'nopadding');
    [W,H,~]=size(SubRaw);
    N=W*H;
    rg=sum(SubRaw(:,:,1),"all")/N;
    gg=sum(SubRaw(:,:,2:3),"all")/(2*N);
    bg=sum(SubRaw(:,:,4),"all")/N;
    lightmean=sqrt((rg^2+gg^2+bg^2)/3);
    SubRaw(:,:,1)=SubRaw(:,:,1)*lightmean/rg;
    SubRaw(:,:,2:3)=SubRaw(:,:,2:3)*lightmean/gg;
    SubRaw(:,:,4)=SubRaw(:,:,4)*lightmean/bg;
    AWBresult=reconstruct_Raw(SubRaw);
end