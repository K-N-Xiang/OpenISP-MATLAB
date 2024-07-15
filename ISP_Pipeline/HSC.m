% Hue Saturation Control
function [HSCresult]= HSC(UV,hue_offset,saturation_gain)
    tic
    hue_offset=hue_offset/180*pi;
    sin_hue=sin(hue_offset);
    cos_hue=cos(hue_offset);
    U=UV(:,:,1);
    V=UV(:,:,2);
    hsc_u_img=cos_hue*(U-0.5)-sin_hue*(V-0.5);
    hsc_u_img=hsc_u_img*saturation_gain+0.5;
    hsc_v_img=sin_hue*(U-0.5)+cos_hue*(V-0.5);
    hsc_v_img=hsc_v_img*saturation_gain+0.5;
    HSCresult=cat(3,hsc_u_img,hsc_v_img);
    HSCresult=min(max(HSCresult,0),1);
    toc
    disp('HSC Complete');
end