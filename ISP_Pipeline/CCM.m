% Color Correction Matrix
function [CCMresult]= CCM(RGB,ccm)
    tic
    [W,H,C]=size(RGB);
    ccm_matrix=transpose(ccm(:,1:3));
    ccm_bias=transpose(ccm(:,4));
    RGB=reshape(RGB,W*H,C);
    CCMresult=RGB*ccm_matrix;
    for i=1:3
        CCMresult(:,i)=CCMresult(:,i)+ccm_bias(i);
    end
    CCMresult = max(min(CCMresult, 1), 0);
    CCMresult=reshape(CCMresult,W,H,C);
    toc
    disp('CCM Complete');
end