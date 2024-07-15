% Chroma Noise Filtering
function [CNFresult]= CNF(Raw,CNF_threshold,gain)
    tic
    SubRaw=split_Raw(Raw,'nopadding');
    [avg_r,avg_g,avg_b,is_r_noise,is_b_noise]= CND(SubRaw,CNF_threshold);
    y=0.299 * avg_r + 0.587 * avg_g + 0.114 * avg_b;
    r_cnc=CNC(SubRaw(:,:,1),avg_g,avg_r,avg_b,y,gain(1));
    b_cnc=CNC(SubRaw(:,:,4),avg_g,avg_b,avg_r,y,gain(4));
    [W,H,~]=size(SubRaw);
    for i=1:W
        for j=1:H
            if(is_r_noise(i,j))
                SubRaw(i,j,1)=r_cnc(i,j);
            end
            if(is_b_noise(i,j))
                SubRaw(i,j,4)=b_cnc(i,j);
            end
        end
    end
    CNFresult=reconstruct_Raw(SubRaw);
    CNFresult = max(min(CNFresult, 1), 0);
    toc
    disp('CNF Complete');
end

% Chroma Noise detect
function [avg_r,avg_g,avg_b,is_r_noise,is_b_noise]= CND(SubRaw,CNF_threshold)
    [W,H,~]=size(SubRaw);
    % 归一化的均值滤波核
    filter_size = 5;  % 滤波器大小，例如 5x5
    mean_kernel = ones(filter_size) / filter_size^2;  
    % 应用均值滤波器
    avg_r = imfilter(SubRaw(:,:,1), mean_kernel);
    avg_g = (imfilter(SubRaw(:,:,2), mean_kernel)+imfilter(SubRaw(:,:,3), mean_kernel))/2;
    avg_b = imfilter(SubRaw(:,:,4), mean_kernel);

    is_r_noise=false([W,H]);
    is_b_noise=false([W,H]);
    for i=1:W
        for j=1:H
            is_r_noise(i,j)=(SubRaw(i,j,1)-avg_g(i,j)>CNF_threshold) && (SubRaw(i,j,1)-avg_b(i,j)>CNF_threshold) &&...
                       (avg_r(i,j)-avg_g(i,j)>CNF_threshold) && (avg_r(i,j)-avg_b(i,j)<CNF_threshold);
            is_b_noise(i,j)=(SubRaw(i,j,4)-avg_g(i,j)>CNF_threshold) && (SubRaw(i,j,4)-avg_r(i,j)>CNF_threshold) &&...
                       (avg_b(i,j)-avg_g(i,j)>CNF_threshold) && (avg_b(i,j)-avg_r(i,j)<CNF_threshold);
        end
    end
end

% Chroma Noise correct
function [CNCresult]= CNC(img,avg_g, avg_c1, avg_c2, y, gain)

    if gain <= 1
        damp_factor = 1;
    elseif 1 < gain && gain <= 1.2
        damp_factor = 0.5;
    else
        damp_factor = 0.3;
    end
    [W,H]=size(img);
    max_avg=max(avg_g,avg_c2);
    signal_gap = img - max_avg;
    chroma_corrected = max_avg + damp_factor*signal_gap;

    fade1=zeros([W,H]);
    fade2=zeros([W,H]);
    for i=1:W
        for j=1:H
            switch true
                case y(i,j) < 0.1176
                    fade1(i,j)=1;
                case y(i,j) < 0.1961
                    fade1(i,j)=0.9;
                case y(i,j) < 0.2745
                    fade1(i,j)=0.8;
                case y(i,j) < 0.3922
                    fade1(i,j)=0.7;
                case y(i,j) < 0.5882
                    fade1(i,j)=0.6;
                case y(i,j) < 0.7843
                    fade1(i,j)=0.3;
                case y(i,j) < 0.9804
                    fade1(i,j)=0.1;
            end
            switch true
                case avg_c1(i,j) < 0.1176
                    fade2(i,j)=1;
                case avg_c1(i,j) < 0.1961
                    fade2(i,j)=0.9;
                case avg_c1(i,j) < 0.2745
                    fade2(i,j)=0.8;
                case avg_c1(i,j) < 0.3922
                    fade2(i,j)=0.6;
                case avg_c1(i,j) < 0.5882
                    fade2(i,j)=0.5;
                case avg_c1(i,j) < 0.7843
                    fade2(i,j)=0.3;
            end
        end
    end
    fade=fade1.*fade2;
    CNCresult=fade.*chroma_corrected+(1-fade).*img;
end