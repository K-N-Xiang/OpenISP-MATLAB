% Black Level Compensation
function [BLCresult]= BLC(Raw,alpha,beta,bl_array)
    SubRaw=split_Raw(Raw,'nopadding');
    SubRaw(:,:,1)=max(SubRaw(:,:,1)-bl_array(1),0);
    SubRaw(:,:,4)=max(SubRaw(:,:,4)-bl_array(4),0);
    SubRaw(:,:,2)=max(SubRaw(:,:,2)-bl_array(2)+SubRaw(:,:,1)*alpha,0);
    SubRaw(:,:,3)=max(SubRaw(:,:,3)-bl_array(3)+SubRaw(:,:,4)*beta,0);
    BLCresult=reconstruct_Raw(SubRaw);
end