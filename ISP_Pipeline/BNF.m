% Bilateral Noise Filtering
function [BNFresult]= BNF(Y,intensity_sigma,spatial_sigma)
    tic
    BNFresult=imbilatfilt(Y,intensity_sigma,spatial_sigma);
    
    %% Mybilatfilt
    % BNFresult=Mybilatfilt(Y,intensity_sigma,spatial_sigma);
    toc
    disp('BNF Complete');
end

function [BNFresult]=Mybilatfilt(Y,intensity_sigma,spatial_sigma)
    Gaussian_kernel=fspecial('gaussian',[5,5],spatial_sigma);
    intensity_weights_lut=get_intensity_weights_lut(intensity_sigma);
    [filterW,filterH]=size(Gaussian_kernel);
    Y=padarray(Y,[floor(filterW/2),floor(filterH/2)],"replicate");
    [W,H]=size(Y);
    BNFresult=zeros([W,H]);
    Gaussian_kernel=Gaussian_kernel(:);
    for i=1+floor(filterW/2):W-floor(filterW/2)
        for j=1+floor(filterH/2):H-floor(filterH/2)
            around_pixel=[Y(i-1,j-1),Y(i,j-1),Y(i+1,j-1),Y(i-1,j),Y(i,j),Y(i+1,j),Y(i-1,j+1),Y(i,j+1),Y(i+1,j+1)];
            around_pixel_diff=around_pixel-Y(i,j);
            weights=0;
            for k=1:size(around_pixel)
                weight=intensity_weights_lut(floor((255*around_pixel_diff(k))^2)+1)*Gaussian_kernel(k);
                BNFresult(i,j)=BNFresult(i,j)+weight*around_pixel(k);
                weights=weights+weight;
            end
            BNFresult(i,j)=BNFresult(i,j)/weights;
        end
    end
    BNFresult=BNFresult(1+floor(filterW/2):W-floor(filterW/2),1+floor(filterH/2):H-floor(filterH/2));
end

function [intensity_weights_lut]=get_intensity_weights_lut(intensity_sigma)
    intensity_diff=0:1:255^2;
    intensity_weights_lut=exp(-intensity_diff/(2.0*(255*intensity_sigma)^2));
end