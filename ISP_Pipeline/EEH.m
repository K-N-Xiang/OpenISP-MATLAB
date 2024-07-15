% Edge Enhancement
function [EEHresult]= EEH(Y,edge_gain,flat_threshold,edge_threshold,delta_top)
    tic
    [W,H]=size(Y);
    t1=flat_threshold;
    t2=edge_threshold;
    t2dt1=max(t2-t1,1e-6);
    middle_slope=edge_gain/t2dt1;
    middle_intercept=-edge_gain*t1/t2dt1;

    Gaussian_filter=fspecial('gaussian',[5,5],1.2);
    delta=Y-imfilter(Y,Gaussian_filter,"replicate");
    % delta=Y-edge(Y,"canny",0.15,1.2);
    abs_delta=abs(delta);
    enhanced_delta=zeros([W,H]);
    for i=1:W
        for j=1:H
            if(abs_delta(i,j)>t1 && abs_delta(i,j)<=t2)
                enhanced_delta(i,j)=middle_slope*abs_delta(i,j)+middle_intercept;
            elseif(abs_delta(i,j)>t2)
                enhanced_delta(i,j)=edge_gain*abs_delta(i,j);
            end
            enhanced_delta(i,j)=min(enhanced_delta(i,j),delta_top)*(delta(i,j)/abs_delta(i,j));
        end
    end
    EEHresult=Y+enhanced_delta;
    EEHresult=min(max(EEHresult,0),1);
    % EEHresult=EEHresult/max(max(EEHresult));
    toc
    disp('EEH Complete');
end