clear
close all
clc

folder_paths = {'./ISP_Pipeline','./utils','./noise_test'};
addpath(folder_paths{:});
%% DPC
DPC_threshold=0.75;
%% BLC
alpha=0;
beta=0;
bl_array=[0.005,0.005,0.005,0.005];


%% 
filename = 'test.raw';
width=1920;
height=1080;

Raw=read_Raw(filename,width,height);

% Raw=add_salt_pepper_noise(Raw,0.0001);
Raw=DPC(Raw,DPC_threshold);
Raw=BLC(Raw,alpha,beta,bl_array);
Raw1=AAF(Raw);
%% 
subplot(1,2,1);
imshow(Raw);
subplot(1,2,2);
imshow(Raw1);