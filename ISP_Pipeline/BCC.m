% Brightness Contrast Control
function [BCCresult]= BCC(Y,brightness_offset,contrast_gain)
    tic
    BCCresult= max(min(Y+brightness_offset, 1), 0);
    medianY=median(BCCresult);
    BCCresult=(BCCresult-medianY)*contrast_gain+medianY;
    BCCresult= max(min(BCCresult, 1), 0);
    toc
    disp('BCC Complete');
end