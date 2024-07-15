% Contrast Enhancement
function [CEHresult]= CEH(Y,x_tiles,y_tiles,clip_limit)
    tic
    % contrast limited adaptive histogram equalization 
    CEHresult=adapthisteq(Y,"NumTiles",[x_tiles,y_tiles],"ClipLimit",clip_limit);
    toc
    disp('CEH Complete');
end