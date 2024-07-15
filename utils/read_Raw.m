function [Raw]= read_Raw(filename,width,height)
    fid = fopen(filename, 'rb');
    raw_data = fread(fid,'uint16');
    len=length(raw_data);
    k=len/(width*height);
    fclose(fid);
    Raw = reshape(raw_data, width, height, k);
    Raw = Raw/max(max(Raw));
end