clear all; close all;

img = imread('image.bmp');
%img = imread('coins.png');
%img = imresize(img,0.3); 
%img = rgb2gray(img);

[I,J] = meshgrid(1:size(img,2),1:size(img,1));

[L,Di,Dj]=gaussmask(5);
img_lisse=conv2(double(img),L,'same');
pts_to_cluster = double([I(:) J(:) img_lisse(:)]);

% Rayon de recherche
bw = 45;

[clustCent,data2cluster] = ac_meanshiftclustering(pts_to_cluster,bw,0);

figure;
imshow(img); hold on;
plot(clustCent(:,1),clustCent(:,2),'b+');

segmentation = reshape(data2cluster,size(img,1),size(img,2));
segmentation = uint8(segmentation*(255/size(clustCent,1)));
figure;
imshow(segmentation);
colormap(autumn)
