
function [matches, confidences] = match_features(features1, features2)

Threshold_test = 0.96; % empirical value
num_features = min(size(features1, 1), size(features2,1)); %% the number of features is minimum of both
matches = zeros(num_features, 2); % pre-allocation for speed
[index_nearest_two,nearest_two_neighbors] = knnsearch(features2,features1,'k',2); %% BONUS
index_feature1 = (1:size(features1,1)); % create features1 index vector
NNDR = nearest_two_neighbors(:,1)./nearest_two_neighbors(:,2); % perform the NNDR test (ratio test)
good_matches = []; % these are the only taken points
mathecs_counter = 1; % increase only if it is a good candidate
for i = 1:length(NNDR)
   if NNDR(i) < Threshold_test
       good_matches = [good_matches NNDR(i)]; % concatenate the good matches
       matches(mathecs_counter,1) = index_feature1(i); % assign the index in the feature1 vector
       matches(mathecs_counter,2) = index_nearest_two(i,1); % assign the index of the first neighbour, hence the "1"
       mathecs_counter = mathecs_counter+1;  % increment the counter
   end
end

[confidences, ind] = sort(good_matches, 'ascend');
matches = matches(ind,:);