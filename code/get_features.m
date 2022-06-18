

function [features] = get_features(image, x, y, descriptor_window_image_width)

%% compute the gradient of the image 
sobel_x = [-1 0 1 ; -2 0 2 ; -1 0 1];
sobel_y = transpose(sobel_x)*-1;
sobel_x_gauss = imgaussfilt(sobel_x);
sobel_y_gauss = imgaussfilt(sobel_y);
im1_x = imfilter(image,sobel_x_gauss,'conv');
im1_y = imfilter(image,sobel_y_gauss,'conv');

%% Get direction 
image_direction = atan2d( im1_y,im1_x);
image_direction(image_direction<0) = image_direction(image_direction<0) +360; 


%% Create a window of 256 values and compute the dominant orientation

% for k = 1:length(x)
%     current_key_point_x = round(x(k));
%     current_key_point_y = round(y(k));
%     start_x = current_key_point_x -7;
%     end_x = current_key_point_x + 8;
%     start_y = current_key_point_y - 7;
%     end_y = current_key_point_y + 8;
% 
%     % compute the histogram for 256 points and assign it 36   bins
%     histo = zeros(1,36);
%     window = image_direction(start_y:end_y,start_x:end_x);
%     [r,c] = size(window);
%     for i = 1:r*c
%         value = window(i);
%         bin_number = ceil((value/360) * 36) ;
%         if bin_number == 0
%             bin_number =1;
%         end
%         histo(bin_number) = histo(bin_number) +1;
%     end
%     %[number_of_occ, max_bin_number] = max(histo);
%     [number_of_occ_sorted,bin_numbers_sorted] = sort(histo,'descend');
% %     dominant_dir = (number_of_occ_sorted(1)/36) * 360; 
% %     image_direction(current_key_point_y,current_key_point_x) =  image_direction(current_key_point_y,current_key_point_x) - dominant_dir;
% %     image_direction(image_direction<0) = image_direction(image_direction<0) +360; % for negative values
%     second_dominant_dir = number_of_occ_sorted(2);
%     if (number_of_occ_sorted(2)/number_of_occ_sorted(1)) > 0.8 % two dom
% %         % new key point
% %         new_point = 
% %         new_key_points = [new_key_points new_point];
%     end
% end
%% Quantize into 8 directions
for i = 1:8
    image_direction(image_direction>=(i-1)*(45) & image_direction<=(i*45) )= i; %% direction qunatize
end

%% Get the feature vectors
features = [];
for k = 1:length(x)
    
    current_key_point_x = round(x(k));
    current_key_point_y = round(y(k));
    % take 7 before and 8 after in both y and x
    start_x = current_key_point_x - 7;
    start_y = current_key_point_y - 7;
    feature_vector =[];
    for counter = 0:15
        % reset the y axis and increase the x axis every 4 iterations.
        % otherwise, keep the same x and increase the y direction
        if mod(counter,4) == 0 
            start_x = start_x + 4;
            end_x = start_x + 3;
            start_y = current_key_point_y -7;
            end_y = start_y + 3;
        elseif mod(counter,4) ~=0 
            start_y = start_y + 4;
            end_y = start_y + 3;
        end
        window = image_direction(start_y:end_y,start_x:end_x);
        % compute the histogram
        histo = zeros(1,8);
        for i = 1:descriptor_window_image_width
            value = window(i);
            histo(value) = histo(value) +1;
        end
        % concatenate the histograms 8*(4*4) = 8*16
        feature_vector = [feature_vector histo];
    end
    % normalize the feature vector 
    feature_vector = normalize(feature_vector,'norm',1); % normalized
    % solve the Illumination probelm -> Th = 0.2
    feature_vector(feature_vector>=0.2) = 0.2;
    feature_vector = normalize(feature_vector,'norm',1); % normalized

    % all 128 points
    % concatenate all the features 
    features = [features;feature_vector];
end

end








