Irgb = imread('fruits.jpg');
Igray = 0.2989*Irgb(:,:,1)+0.5870*Irgb(:,:,2)+0.1140*Irgb(:,:,3);
figure
image(Igray,'CDataMapping','scaled');
colormap('gray')
title('Input Image in Grayscale')
% 
% figure
% image(Igray,'CDataMapping','scaled');
% colormap('gray')
% title('Input Image in Grayscale')
I = double(Igray);
% 
classType = class(Igray);
scalingFactor = double(intmax(classType));
I = I/scalingFactor;
% 
Gx = [-1 1];
Gy = Gx';
Ix = conv2(I,Gx,'same');
Iy = conv2(I,Gy,'same');
% 
figure
image(Ix,'CDataMapping','scaled')
colormap('gray')
title('Ix')

figure
image(Iy,'CDataMapping','scaled')
colormap('gray')
title('Iy')

t2fis=readt2fis('imageProcessing.t2fis');

Ieval = zeros(size(I));
for ii = 1:size(I,1)
    disp(ii);
    for jj = 1:length(I)
        Ieval(ii,jj) = evalt2([(Ix(ii,jj));(Iy(ii,jj));]',t2fis); 
    end
end

figure
image(I,'CDataMapping','scaled')
colormap('gray')
title('Original Grayscale Image')

figure
image(Ieval,'CDataMapping','scaled')
colormap('gray')
title('Edge Detection Using Fuzzy Logic')


