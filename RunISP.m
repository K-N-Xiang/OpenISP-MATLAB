clear
close all
clc

folder_paths = {'./ISP_Pipeline','./utils'};
addpath(folder_paths{:});
%% 
DPC_threshold=1;

%% 
filename = 'C:\Users\Kainan Xiang\Desktop\MyISP\test.RAW';
width=1920;
height=1080;

Raw=read_Raw(filename,width,height);
Raw=DPC(Raw,DPC_threshold);
%% 