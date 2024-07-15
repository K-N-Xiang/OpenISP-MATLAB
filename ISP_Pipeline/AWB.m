% Auto White Balance
function [AWBresult,Gain]=AWB(Raw,Method)
    tic
    SubRaw=split_Raw(Raw,'nopadding');
    [W,H,~]=size(SubRaw);
    N=W*H;
    if strcmp(Method, 'GrayWorld')
        rg=sum(SubRaw(:,:,1),"all")/N;
        gg=sum(SubRaw(:,:,2:3),"all")/(2*N);
        bg=sum(SubRaw(:,:,4),"all")/N;
        SubRaw(:,:,1)=SubRaw(:,:,1)*gg/rg;
        SubRaw(:,:,4)=SubRaw(:,:,4)*gg/bg;
        Gain=[gg/rg,1,1,gg/bg];
    elseif strcmp(Method, 'WhitePatch')
        rmax=max(max(SubRaw(:,:,1)));
        gmax=max(max(max(SubRaw(:,:,2:3))));
        bmax=max(max(SubRaw(:,:,4)));
        allmax=max([rmax,gmax,bmax]);
        SubRaw(:,:,1)=SubRaw(:,:,1)*allmax/rmax;
        SubRaw(:,:,2:3)=SubRaw(:,:,2:3)*allmax/gmax;
        SubRaw(:,:,4)=SubRaw(:,:,4)*allmax/bmax;
        Gain=[rmax/gmax,1,1,bmax/gmax];
    end
    AWBresult=reconstruct_Raw(SubRaw);
    AWBresult = max(min(AWBresult, 1), 0);
    toc
    disp('AWB Complete');
end