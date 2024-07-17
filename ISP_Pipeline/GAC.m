% Gamma Correction
function [GACresult]= GAC(RGB,gamma)
    if nargin<2
        GACresult=autoGAC(RGB);
    else
        GACresult=fixedGAC(RGB,gamma);
    end
end

function [GACresult]= autoGAC(RGB)
    tic
    meanR=mean(mean(RGB(:,:,1)));
    meanG=mean(mean(RGB(:,:,2)));
    meanB=mean(mean(RGB(:,:,3)));
    mean_all=(meanR+meanG+meanB)/3;
    gamma=1/(log10(1/2)/log10(mean_all));
    GACresult=RGB.^(1/gamma);
    GACresult = max(min(GACresult, 1), 0);
    toc
    disp('GAC Complete');
end

function [GACresult]= fixedGAC(RGB,gamma)
    tic
    GACresult=RGB.^(1/gamma);
    GACresult = max(min(GACresult, 1), 0);
    toc
    disp('GAC Complete');
end