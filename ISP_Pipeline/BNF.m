% Bilateral Noise Filtering
function [BNFresult]= BNF(Y,intensity_sigma,spatial_sigma)
    tic
    BNFresult=imbilatfilt(Y,intensity_sigma,spatial_sigma);
    toc
    disp('BNF Complete');
end