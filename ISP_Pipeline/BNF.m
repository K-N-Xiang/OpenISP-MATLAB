% Bilateral Noise Filtering
function [BNFresult]= BNF(Y,intensity_sigma,spatial_sigma)
    BNFresult=imbilatfilt(Y,intensity_sigma,spatial_sigma);
end