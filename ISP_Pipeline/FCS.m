% False Color Suppression
function [FCSresult]= FCS(YUV,delta_min,delta_max)
    tic
    Y=YUV(:,:,1);
    UV=YUV(:,:,2:3);
    delta_threshold=max(delta_max-delta_min,1e-6);
    slope=-1/delta_threshold;
    Gaussian_filter=fspecial('gaussian',[5,5],1.2);
    delta=Y-imfilter(Y,Gaussian_filter,"replicate");
    abs_delta=abs(delta);
    gain_map=slope*(abs_delta-delta_max);
    gain_map=min(max(gain_map,0),1);
    fcs_UV=gain_map.*(UV-0.5)+0.5;
    FCSresult=cat(3,Y,fcs_UV);
    toc
    disp('FCS Complete');
end