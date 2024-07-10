clear
close all
clc

folder_paths = {'./ISP_Pipeline','./utils','./noise_test'};
addpath(folder_paths{:});
%% Gain
gain=1;
%% DPC
DPC_threshold=0.75;
%% BLC
alpha=0;
beta=0;
bl_array=[0.005,0.005,0.005,0.005];
%% CNF
CNF_threshold=0;
%% CCM
ccm=[[1, 0, 0, 0];
     [0, 1, 0, 0];
     [0, 0, 1, 0]];
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
%% FCS
delta_min=0.0512;
delta_max=0.25;
%% HSC
hue_offset=0;
saturation_gain=1;

%% Test
filename = './Raw/test.raw';
width=1920;
height=1080;

Raw=read_Raw(filename,width,height);

% Raw=add_salt_pepper_noise(Raw,0.0001);
Raw1=DPC(Raw,DPC_threshold);
Raw1=BLC(Raw1,alpha,beta,bl_array);
Raw1=AAF(Raw1);
Raw1=AWB(Raw1);
Raw1=CNF(Raw1,CNF_threshold,gain);
RGB=CFA(Raw1);
RGB1=CCM(RGB,ccm);
RGB1=GAC(RGB1,gamma);
YUV=CSC(RGB1);
YUV1=YUV;
YUV1(:,:,1)=NLM(YUV1(:,:,1),search_window_size,patch_size,h);
YUV1(:,:,1)=BNF(YUV1(:,:,1),intensity_sigma,spatial_sigma);
YUV1(:,:,1)=EEH(YUV1(:,:,1),edge_gain,flat_threshold,edge_threshold,delta_top);
YUV1(:,:,1)=CEH(YUV1(:,:,1),x_tiles,y_tiles);
YUV1=FCS(YUV1,delta_min,delta_max);
YUV1(:,:,2:3)=HSC(YUV1(:,:,2:3),hue_offset,saturation_gain);
result=CSC_(YUV1);
%% 
subplot(1,7,1);
imshow(Raw);
subplot(1,7,2);
imshow(Raw1);
subplot(1,7,3);
imshow(RGB);
subplot(1,7,4);
imshow(RGB1);
subplot(1,7,5);
imshow(YUV);
subplot(1,7,6);
imshow(YUV1);
subplot(1,7,7);
imshow(result);
imwrite(imrotate(result,-90),"./result/test_result.bmp");