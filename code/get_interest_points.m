
function [x, y, confidence, scale, orientation] = get_interest_points(image, descriptor_window_image_width,im_n)


%% Step 1 : Compute x and y derivatives of the image
sobel_x = [-1 0 1 ; -2 0 2 ; -1 0 1];
sobel_y = transpose(sobel_x)*-1;
sobel_x_gauss = imgaussfilt(sobel_x);
sobel_y_gauss = imgaussfilt(sobel_y);
Ix = imfilter(image,sobel_x_gauss,'conv');
Iy = imfilter(image,sobel_y_gauss,'conv');

%% Step 2 : Compute products of derivatives at every pixel
Ix2 = Ix.*Ix;
Iy2 = Iy .*Iy;
Ixy = Ix .*Iy;

%% Step 3 : Compute the sums of products of derivaties at each pixel
Sx2 = imgaussfilt(Ix2);
Sy2 = imgaussfilt(Iy2);
Sxy = imgaussfilt(Ixy);
 
%% Step 4 : define the matrix H at each pixel
[r,c] = size(image);
det_H = Sx2 .*Sy2 - Sxy.*Sxy;
trace_H = Sx2 + Sy2;

%% Step 5 : Compute the respone of the detector at each pixel
R = det_H - 0.04*(trace_H).^2;


%% Step 6 : Apply non maximum suppresion using 5*5 window
x = []; % this will be the interest point coordinates in x
y = []; % this will be the interest point coordinates in y
t = 0.002;
for i = 8:1:c-20 % columns ( start from 8 and end with c-20, so we discard the corners of the image )
    for j = 8:1:r-20 % rows ( same )
        % Get the current pixel R value and compare it to the 8 values
        % around it ( 3*3 window ). 
        current_pixel_R = R(j,i); 
        start_x = j-1; 
        start_y = i-1;
        end_x = j+1;
        end_y = i+1;
        window = R(start_x:end_x,start_y:end_y);  

        values_sorted = sort(reshape(window, [9,1]),'descend'); % sort the window and reshape it to be a vector
        if current_pixel_R >t % got this value from trial and error 
            if current_pixel_R == values_sorted(1) % if the current value is the maximum-> add its coordinates
                x = [x i];
                y = [y j];
            end
        end
    end
end
x = x'; % transponse to be a column vector
y = y';
figure;

imshow(image);
hold on
scatter(x,y);
title("The image number"+string(im_n)+" with all interest points and Threshold of" +string(t) );
end

