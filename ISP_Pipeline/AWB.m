% Auto White Balance
function [AWBresult,Gain]=AWB(Raw,Method)
    tic
    SubRaw=split_Raw(Raw,'nopadding');
    [W,H,~]=size(SubRaw);
    N=W*H;
    if strcmp(Method, 'GrayWorld')
        rg=sum(SubRaw(:,:,1),"all")/N;
        gg=sum(SubRaw(:,:,2:3),"all")/(2*N);
        bg=sum(SubRaw(:,:,4),"all")/N;
        SubRaw(:,:,1)=SubRaw(:,:,1)*gg/rg;
        SubRaw(:,:,4)=SubRaw(:,:,4)*gg/bg;
        Gain=[gg/rg,1,1,gg/bg];
    elseif strcmp(Method, 'WhitePatch')
        rmax=max(max(SubRaw(:,:,1)));
        gmax=max(max(max(SubRaw(:,:,2:3))));
        bmax=max(max(SubRaw(:,:,4)));
        allmax=max([rmax,gmax,bmax]);
        SubRaw(:,:,1)=SubRaw(:,:,1)*allmax/rmax;
        SubRaw(:,:,2:3)=SubRaw(:,:,2:3)*allmax/gmax;
        SubRaw(:,:,4)=SubRaw(:,:,4)*allmax/bmax;
        Gain=[rmax/gmax,1,1,bmax/gmax];
    elseif strcmp(Method, 'PCA')
        flat_img(:,:,1)=SubRaw(:,:,1);
        flat_img(:,:,2)=(SubRaw(:,:,3)+SubRaw(:,:,2))/2;
        flat_img(:,:,3)=SubRaw(:,:,4);
        flat_img=reshape(flat_img,N,3);
        mean_rgb = mean(flat_img, 1);
        mean_vector = mean_rgb / norm(mean_rgb);
        data_p = sum(flat_img .* mean_vector, 2);
        [~, sorted_data] = sort(data_p);
        index = ceil(N * (5 / 100));
        filtered_index = [sorted_data(1:index); sorted_data(end-index+1:end)];
        filtered_data = single(flat_img(filtered_index, :));
        sigma = filtered_data' * filtered_data;
        [eig_vector, eig_value] = eig(sigma);
        [~, max_index] = max(diag(eig_value));
        avg_rgb = abs(eig_vector(:, max_index));
        rgain = avg_rgb(2) / avg_rgb(1);
        bgain = avg_rgb(2) / avg_rgb(3);
        SubRaw(:,:,1)=SubRaw(:,:,1)*rgain;
        SubRaw(:,:,4)=SubRaw(:,:,4)*bgain;
        Gain=[rgain,1,1,bgain];
    end
    AWBresult=reconstruct_Raw(SubRaw);
    AWBresult = max(min(AWBresult, 1), 0);
    toc
    disp('AWB Complete');
end
