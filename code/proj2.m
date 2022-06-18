
clear 
clc 
close all
imagePair = 1;
if imagePair == 1
    % Notre Dame de Paris
    % Easiest
    image1 = imread('../data/NotreDame/921919841_a30df938f2_o.jpg');
    image2 = imread('../data/NotreDame/4191453057_c86028ce1f_o.jpg');
    eval_file = '../data/NotreDame/921919841_a30df938f2_o_to_4191453057_c86028ce1f_o.mat';
elseif imagePair == 2
    % Mount Rushmore 
    % A little harder than Notre Dame
    image1 = imread('../data/MountRushmore/9021235130_7c2acd9554_o.jpg');
    image2 = imread('../data/MountRushmore/9318872612_a255c874fb_o.jpg');
    eval_file = '../data/MountRushmore/9021235130_7c2acd9554_o_to_9318872612_a255c874fb_o.mat';
elseif imagePair == 3
    % Gaudi's Episcopal Palace
    % This pair is difficult
    image1 = imread('../data/EpiscopalGaudi/4386465943_8cf9776378_o.jpg');
    image2 = imread('../data/EpiscopalGaudi/3743214471_1b5bbfda98_o.jpg');
    eval_file = '../data/EpiscopalGaudi/4386465943_8cf9776378_o_to_3743214471_1b5bbfda98_o.mat';
end

scale_factor = 0.5;
image1 = im2single( imresize( image1, scale_factor, 'bilinear') );
image2 = im2single( imresize( image2, scale_factor, 'bilinear') );
image1g = rgb2gray(image1);
image2g = rgb2gray(image2);


[x1, y1, x2, y2, matches, confidences] = compute_correspondences( image1g, image2g,eval_file,scale_factor );


num_pts_to_visualize = min(100,size(matches,1));

show_correspondence(image1, image2, x1(matches(1:num_pts_to_visualize,1)), ...
                                     y1(matches(1:num_pts_to_visualize,1)), ...
                                     x2(matches(1:num_pts_to_visualize,2)), ...
                                     y2(matches(1:num_pts_to_visualize,2)), ...
                                 'arrows', 'vis_arrows.png');


num_pts_to_evaluate = min(100,size(matches,1));

[numGoodMatches,numBadMatches,precision,accuracy100] = evaluate_correspondence(image1, image2, eval_file, scale_factor, ... 
                        x1(matches(1:num_pts_to_evaluate,1)), ...
                        y1(matches(1:num_pts_to_evaluate,1)), ...
                        x2(matches(1:num_pts_to_evaluate,2)), ...
                        y2(matches(1:num_pts_to_evaluate,2)), ...
                        true ); % Visualize/write result

