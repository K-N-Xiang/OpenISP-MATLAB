function [SubRaw]= split_Raw(Raw,ispadding)
    [W,H]=size(Raw);
    if strcmp(ispadding, 'padding')
        R=zeros([W H]);Gr=zeros([W H]);Gb=zeros([W H]);B=zeros([W H]);
        for i=1:W/2
            for j=1:H/2
                R(2*i-1,2*j-1)=Raw(2*i-1,2*j-1);
                Gr(2*i-1,2*j)=Raw(2*i-1,2*j);
                Gb(2*i,2*j-1)=Raw(2*i,2*j-1);
                B(2*i,2*j)=Raw(2*i,2*j);
            end
        end
        SubRaw=cat(3,R,Gr,Gb,B);
    else
        R=zeros([W/2 H/2]);Gr=zeros([W/2 H/2]);Gb=zeros([W/2 H/2]);B=zeros([W/2 H/2]);
        for i=1:W/2
            for j=1:H/2
                R(i,j)=Raw(2*i-1,2*j-1);
                Gr(i,j)=Raw(2*i-1,2*j);
                Gb(i,j)=Raw(2*i,2*j-1);
                B(i,j)=Raw(2*i,2*j);
            end
        end
        SubRaw=cat(3,R,Gr,Gb,B);
    end
end