%  IT2-FLS Toolbox is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     IT2-FLS Toolbox is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with IT2-FLS Toolbox.  If not, see <http://www.gnu.org/licenses/>.
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

%% Define Type Reduction Method 
%  TRMethod='KM' -> 1, 'EKM'-> 2, 'IASC' -> 3, 'EIASC' -> 4, 'EODS' -> 5, 'WM' -> 6, 'NT' -> 7, 'BMM' -> 8 
TRMethod = 1;

%%
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
        Ieval(ii,jj) = evalt2([(Ix(ii,jj));(Iy(ii,jj));]',t2fis,TRMethod); 
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


