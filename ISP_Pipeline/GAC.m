% Gamma Correction
function [GACresult]= GAC(RGB,gamma)
    tic
    GACresult=RGB.^(1/gamma);
    GACresult = max(min(GACresult, 1), 0);
    toc
    disp('GAC Complete');
end