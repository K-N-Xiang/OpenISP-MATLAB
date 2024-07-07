% Gamma Correction
function [GACresult]= GAC(RGB,gamma)
    GACresult=RGB.^(1/gamma);
end