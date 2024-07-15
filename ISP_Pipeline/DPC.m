% Dead Pixel Correction
function [DPCresult]= DPC(Raw,threshold)
    tic
    Raw=padarray(Raw,[2 2],'replicate');
    SubRaw=split_Raw(Raw,'nopadding');
    [W,H,C]=size(SubRaw);
    for k=1:C
        mask=false([W-2,H-2]);
        dpc_array=zeros([W-2,H-2]);
        for i=2:W-1
            for j=2:H-1
                 around_pixel = [SubRaw(i-1, j-1,k) SubRaw(i,j-1,k) SubRaw(i+1,j-1,k) SubRaw(i-1,j,k) SubRaw(i+1,j,k) SubRaw(i-1,j+1,k) SubRaw(i,j+1,k) SubRaw(i+1,j+1,k)];
                 diff = around_pixel - ones(1, numel(around_pixel)) * SubRaw(i,j,k);
                if (((nnz(diff > 0) ==  numel(around_pixel)) || (nnz(diff < 0) ==  numel(around_pixel))) && (length(find((abs(diff)>threshold)==1)) == numel(around_pixel)))
                    mask(i-1,j-1)=~mask(i-1,j-1);
    
                    dv=abs(2*SubRaw(i,j,k)-SubRaw(i-1,j,k)-SubRaw(i+1,j,k));
                    dh=abs(2*SubRaw(i,j,k)-SubRaw(i,j-1,k)-SubRaw(i,j+1,k));
                    ddl=abs(2*SubRaw(i,j,k)-SubRaw(i-1,j-1,k)-SubRaw(i+1,j+1,k));
                    ddr=abs(2*SubRaw(i,j,k)-SubRaw(i-1,j+1,k)-SubRaw(i+1,j-1,k));
                    [~,index]=min([dv,dh,ddl,ddr]);
                    neighbor_stack=[SubRaw(i-1,j,k)+SubRaw(i+1,j,k),...
                                    SubRaw(i,j-1,k)+SubRaw(i,j+1,k),...
                                    SubRaw(i-1,j-1,k)+SubRaw(i+1,j+1,k),...
                                    SubRaw(i-1,j+1,k)+SubRaw(i+1,j-1,k)
                                    ];
                    dpc_array(i-1,j-1)=neighbor_stack(index);
                end
            end
        end
        SubRaw(2:W-1,2:H-1,k)=mask.*dpc_array+(~mask).*SubRaw(2:W-1,2:H-1,k);
    end
    DPCresult=reconstruct_Raw(SubRaw);
    DPCresult=DPCresult(3:2*W-2,3:2*H-2);
    toc
    disp('DPC Complete');
end