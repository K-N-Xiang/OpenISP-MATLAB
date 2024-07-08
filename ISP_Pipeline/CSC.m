% Color Space Conversion
function [CSCresult]= CSC(RGB)
    [W,H,C]=size(RGB);
    conversion_matrix=transpose([[0.299, 0.587, 0.114];
                       [-0.1687, -0.3313, 0.5];
                       [0.5, -0.4187, -0.0813]]);
    conversion_bias=[0,0.5,0.5];
    RGB=reshape(RGB,W*H,C);
    CSCresult=RGB*conversion_matrix;
    for i=1:3
        CSCresult(:,i)=CSCresult(:,i)+conversion_bias(i);
    end
    CSCresult=reshape(CSCresult,W,H,C);
end