% Lens Shading Correction
function [LSCresult]= LSC(Raw)
    tic
    [W, H] = size(Raw);
    [x, y] = meshgrid(1:H, 1:W);
    xNorm = (x - H/2) / (H/2);
    yNorm = (y - W/2) / (W/2);
    r = sqrt(xNorm.^2 + yNorm.^2);
    degree = 10;
    coeffs = polyfit(r(:), Raw(:), degree);
    vignettingEffect = polyval(coeffs, r);
    correctionFactor = max(vignettingEffect(:)) ./ vignettingEffect;
    [~, sortIdx] = sort(r(:),'descend'); 
    sorted_correctionFactor = correctionFactor(sortIdx);
    for i = 2:numel(sorted_correctionFactor)
        if sorted_correctionFactor(i) > sorted_correctionFactor(i-1)
            sorted_correctionFactor(i) = sorted_correctionFactor(i-1);
        end
    end
    correctionFactor(sortIdx) = sorted_correctionFactor;
    correctionFactor = max(min(correctionFactor, 2), 0);
    LSCresult=Raw.*correctionFactor;
    toc
    disp('LSC Complete');
end