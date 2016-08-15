clear all;
clc;
% to declare variables
radius=1;
sigma=1;
threshold=350;
size=2*radius + 1;               %size of matrix filter
dx=[-1 0 1; -1 0 1; -1 0 1];     %x derivative mask
dy=dx';                          %y derivative mask
g=fspecial('gaussian', max(1, fix(6*sigma)), sigma);

%read image
source=imread('blur4(k=31).jpg');
% to get all reds
im=source(:,:,1);

% step 1: compute derivatives of image
Ix=conv2(im, dx, 'same');
Iy=conv2(im, dy, 'same');

% step  2: smooth space image derivatives
Ix2=conv2(Ix.^2, g, 'same');
Iy2=conv2(Iy.^2, g, 'same');
Ixy=conv2(Ix.*Iy, g, 'same');

%step 3: Harris corner measure
harris=(Ix2.*Iy2 - Ixy.^2)./(Ix2 + Iy2 + eps);

%step 4: Find local maxima
mx=ordfilt2(harris, size.^2, ones(size));

harris=(harris==mx)&(harris>threshold);


%plot
[rows, cols]=find(harris);
figure, image(source), axis image, colormap(gray), hold on,
plot(cols, rows, 'ys'), title('corner');



