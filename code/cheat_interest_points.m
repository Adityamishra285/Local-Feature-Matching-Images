function [x1, y1, x2, y2] = cheat_interest_points(eval_file, scale_factor,image)

load(eval_file)

x1 = x1 .* scale_factor;
y1 = y1 .* scale_factor;
x2 = x2 .* scale_factor;
y2 = y2 .* scale_factor;
figure;
imshow(image);
hold on
scatter(x2,y2);
end

