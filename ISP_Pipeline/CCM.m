% Color Correction Matrix
function [CCMresult]= CCM(RGB,ccm)
    [W,H,C]=size(RGB);
    ccm_matrix=ccm(:,1:3);
    ccm_bias=transpose(ccm(:,4));
    RGB=reshape(RGB,W*H,C);
    CCMresult=RGB*ccm_matrix;
    for i=1:3
        CCMresult(:,i)=CCMresult(:,i)+ccm_bias(i);
    end
    CCMresult=reshape(CCMresult,W,H,C);
end