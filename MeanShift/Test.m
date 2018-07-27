clear all; close all;

% Nombre de points
nbPts = 1000;

plotFlag = 1;

%I = imread('heatmap.png');
load prediction10020_hand_tip_right.mat;
I = prediction10020_hand_tip_right;

%I = rgb2gray(I);
pts_to_cluster = double(samplingpoints(I,nbPts));

figure;
imshow(I./max(I(:)), 'Colormap',jet(256)); hold on;
plot(pts_to_cluster(:,1),pts_to_cluster(:,2),'r.');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Rayon de recherche
bw = 5;

[clustCent,data2cluster] = ac_meanshiftclustering(pts_to_cluster,bw,plotFlag);

% Estimation du mélange de gaussiennes et génération d'une image
means = clustCent;
covs = zeros(2,2,size(clustCent,1));
weight = [];
for k=1:size(clustCent,1)
   f = find(data2cluster==k);
   covs(:,:,k) = cov(pts_to_cluster(f,:));
   weight = [weight length(f)];
end

z = plot_gaussian_mixture(means,covs,weight,[360 640]);
figure;
subplot(1,2,1); imshow(I);
subplot(1,2,2); imshow(z);
