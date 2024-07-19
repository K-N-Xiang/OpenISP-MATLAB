clear
close all
clc

folder_paths = {'./ISP_Pipeline','./utils'};
addpath(folder_paths{:});
%% DPC
DPC_threshold=0.1175;
%% BLC
alpha=0;
beta=0;
bl_array=[0.005,0.005,0.005,0.005];
%% CNF
CNF_threshold=0;
%% CCM
ccm=[[1670, -508, -139, 0];
     [-20, 1404, -360, 0];
     [58, -406, 1372, 0]]/1024;
%% GAC
gamma=2.2;
%% NLM
search_window_size=9;
patch_size=3;
h=10;
%% BNF
intensity_sigma=0.8;
spatial_sigma=0.8;
%% EEH
edge_gain=1.5;                  
flat_threshold=0.0512;                   
edge_threshold=0.1024;            
delta_top=0.25;
%% CEH
x_tiles=6;
y_tiles=4;
clip_limit=0.005;
%% FCS
delta_min=0.0512;
delta_max=0.25;
%% HSC
hue_offset=0;
saturation_gain=1;
%% BCC
brightness_offset=0;
contrast_gain=1.015;


%% Test
filename = './Raw/connan_raw14.raw';
width=6080;
height=4044;

tic

Raw=read_Raw(filename,width,height);

Raw=DPC(Raw,DPC_threshold);
imwrite(fliplr(imrotate(Raw,-90)),"./result/DPC.png");

Raw=BLC(Raw,alpha,beta,bl_array);
imwrite(fliplr(imrotate(Raw,-90)),"./result/BLC.png");

Raw=LSC(Raw);
imwrite(fliplr(imrotate(Raw,-90)),"./result/LSC.png");

Raw=AAF(Raw);
imwrite(fliplr(imrotate(Raw,-90)),"./result/AAF.png");

[Raw,Gain]=AWB(Raw,'PCA');
imwrite(fliplr(imrotate(Raw,-90)),"./result/AWB.png");

Raw=CNF(Raw,CNF_threshold,Gain);
imwrite(fliplr(imrotate(Raw,-90)),"./result/CNF.png");

RGB=CFA(Raw);
imwrite(fliplr(imrotate(RGB,-90)),"./result/CFA.png");

RGB=CCM(RGB,ccm);
imwrite(fliplr(imrotate(RGB,-90)),"./result/CCM.png");

RGB=GAC(RGB,gamma);
imwrite(fliplr(imrotate(RGB,-90)),"./result/GAC.png");

YUV=CSC(RGB);
imwrite(fliplr(imrotate(CSC_(YUV),-90)),"./result/CSC.png");

YUV(:,:,1)=NLM(YUV(:,:,1),search_window_size,patch_size,h);
imwrite(fliplr(imrotate(CSC_(YUV),-90)),"./result/NLM.png");

YUV(:,:,1)=BNF(YUV(:,:,1),intensity_sigma,spatial_sigma);
imwrite(fliplr(imrotate(CSC_(YUV),-90)),"./result/BNF.png");

YUV(:,:,1)=EEH(YUV(:,:,1),edge_gain,flat_threshold,edge_threshold,delta_top);
imwrite(fliplr(imrotate(CSC_(YUV),-90)),"./result/EEH.png");

YUV(:,:,1)=CEH(YUV(:,:,1),x_tiles,y_tiles,clip_limit);
imwrite(fliplr(imrotate(CSC_(YUV),-90)),"./result/CEH.png");

YUV=FCS(YUV,delta_min,delta_max);
imwrite(fliplr(imrotate(CSC_(YUV),-90)),"./result/FCS.png");

YUV(:,:,2:3)=HSC(YUV(:,:,2:3),hue_offset,saturation_gain);
imwrite(fliplr(imrotate(CSC_(YUV),-90)),"./result/HSC.png");

YUV(:,:,1)=BCC(YUV(:,:,1),brightness_offset,contrast_gain);
imwrite(fliplr(imrotate(CSC_(YUV),-90)),"./result/BCC.png");

toc
disp('ISP Complete');