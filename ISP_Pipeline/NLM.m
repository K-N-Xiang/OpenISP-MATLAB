% Non-Local Means Denoising
function [NLMresult]= NLM(Y,search_window_size,patch_size,h)
    tic
    NLMresult=imnlmfilt(Y,"SearchWindowSize",search_window_size,"ComparisonWindowSize",patch_size,"DegreeOfSmoothing",h);
    %% 
    % NLMresult=Mynlmfilt(Y,search_window_size,patch_size,h);
    toc
    disp('NLM Complete');
end

function [NLMresult]= Mynlmfilt(Y,search_window_size,patch_size,h)
    pad_size=floor(search_window_size/2);
    Y=padarray(Y,[pad_size pad_size],'replicate');
    [W,H]=size(Y);  
    NLMresult=zeros([W,H]);
    distance_weights_lut=get_distance_weights_lut(h);
    for i=pad_size+1:W-pad_size
        for j=pad_size+1:H-pad_size
            i
            NLMresult(i,j)=NLM_weight_count(Y,i,j,pad_size,patch_size,distance_weights_lut);
        end
    end
    NLMresult=NLMresult(pad_size+1:W-pad_size,pad_size+1:H-pad_size);
end


function [weights_count_result]=NLM_weight_count(Y,x,y,pad_size,patch_size,distance_weights_lut)
    patch_size_half=floor(patch_size/2);
    ref_block=Y(x-patch_size_half:x+patch_size_half,y-patch_size_half:y+patch_size_half);
    weight=0;
    weight_value=0;
    for i=x-pad_size+1:x+pad_size-1
        for j=y-pad_size+1:y+pad_size-1
            mat_block=Y(i-patch_size_half:i+patch_size_half,j-patch_size_half:j+patch_size_half);
            distance=round(sum(((ref_block-mat_block).*255).^2,"all")/pad_size^2);
            weight=weight+distance_weights_lut(distance+1);
            weight_value=weight_value+distance_weights_lut(distance+1)*Y(i,j);
        end
    end
    weights_count_result=weight_value/weight;
end

function [distance_weights_lut]=get_distance_weights_lut(h)
    distance=0:1:255^2;
    distance_weights_lut=exp(-distance/h^2);
end