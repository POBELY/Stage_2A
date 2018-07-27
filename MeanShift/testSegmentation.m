clear all; close all;

img = imread('onion.png');
img = imresize(img,0.5); 

[I,J] = meshgrid(1:size(img,2),1:size(img,1));

img_RGB = double(reshape(img,size(img,1)*size(img,2),size(img,3))');
img_LUV = rgb2luv(img_RGB/255);


pts_to_cluster = double([I(:) J(:) img_LUV(1,:)' img_LUV(2,:)' img_LUV(3,:)' ]);

% Rayon de recherche
bw = 20;

[clustCent,data2cluster] = ac_meanshiftclustering(pts_to_cluster,bw,0);

segmentation = reshape(data2cluster,size(img,1),size(img,2));
segmentation = uint8(segmentation*(255/size(clustCent,1)));

%test = 
for k=1:size(clustCent,1)
    f = find(data2cluster==k);
    img_LUV(:,f) = repmat(clustCent(k,3:5)',1,length(f));
    
end

img_LUV_segmentee = reshape(img_LUV',size(img,1),size(img,2),size(img,3));
img_RGB_segmentee = luv2rgb(img_LUV_segmentee);

figure;
subplot(1,2,1); imshow(img);
subplot(1,2,2); imshow(uint8(255*img_RGB_segmentee));
