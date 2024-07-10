% Color Space Conversion (YUV to RGB)
function [CSC_result]= CSC_(YUV)
    [W,H,C]=size(YUV);
    conversion_matrix=transpose([[1, 0, 1.402];
                       [1, -0.34414, -0.71414];
                       [1, 1.772, 0]]);
    conversion_bias=[0,0.5,0.5];
    YUV=reshape(YUV,W*H,C);
    for i=1:3
        YUV(:,i)=YUV(:,i)-conversion_bias(i);
    end
    CSC_result=YUV*conversion_matrix;
    CSC_result=reshape(CSC_result,W,H,C);
    CSC_result=min(max(CSC_result,0),1);
end