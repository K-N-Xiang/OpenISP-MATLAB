% Contrast Enhancement
function [CEHresult]= CEH(Y,x_tiles,y_tiles)
    % contrast limited adaptive histogram equalization 
    CEHresult=adapthisteq(Y,"NumTiles",[x_tiles,y_tiles]);
end