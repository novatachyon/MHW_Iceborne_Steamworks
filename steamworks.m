%% Code to test different guessing methods for the Monster Hunter World Iceborne 'Steamworks'

clear all; close all;
rng('shuffle'); %shuffles the random number generator

%% Main Loop and methods to run

n = 100000; %number of iterations to run

random_method = zeros(1,2); %array to store points accumulated by random guess method
% the first value is the number of times all three values were guessed correctly, 
% and the second value is the number of times only one value was guessed correctly.

R2_method = zeros(1,2); %array to store points for holding R2 (always guesses 1,2,3)

no_repeat_method = zeros(1,2); %array to store points for a method where you always
% choose a different starting value than the previous correct answer. i.e.
% if the correct answer was (2 3 1), then you would choose randomly between
% 3 and 1 as the first value and only allow 2 to be the second or third
% value

R2_guess = [1 2 3]; %holding R2 always generates this guess sequence, so we only need to make it once!

% this loops over all iterations, and generates a randomly correct
% steamwork combination, and tests each method against it
for i = 1:n
   steamwork = randperm(3); %creates the random correct answer for the steamwork
   random_guess = randperm(3); %creates the random guess
   if i == 1
      no_repeat_guess = randperm(3); %first guess is random since we don't have any previous info
   else
      no_repeat_guess = zeros(1,3); %array for the no first repeat method guess
      no_repeat_guess(1) = prev_answer(randi([2,3],1)); %first guess can't be the first value from last answer
      prev_answer(prev_answer == no_repeat_guess(1)) = []; %deletes the used guess from available values
      no_repeat_guess(2) = prev_answer(randi([1,2],1)); %second guess is random from two remaining values
      prev_answer(prev_answer == no_repeat_guess(2)) = []; %deletes the used guess from available values
      no_repeat_guess(3) = prev_answer; %only one value can be guessed third
   end
   
   random_val = sum( random_guess == steamwork ); %number of correct values from random guess method
   no_repeat_val = sum( no_repeat_guess == steamwork ); %correct guesses from no repeat method
   R2_val = sum( R2_guess == steamwork ); %number of correct guesses from R2 holding method
   
   if random_val == 1
      random_method(2) = random_method(2) + 1; 
   elseif random_val ==3
      random_method(1) = random_method(1) + 1; 
   end

   if no_repeat_val == 1
      no_repeat_method(2) = no_repeat_method(2) + 1; 
   elseif no_repeat_val ==3
      no_repeat_method(1) = no_repeat_method(1) + 1; 
   end   
   
   if R2_val == 1
      R2_method(2) = R2_method(2) + 1; 
   elseif R2_val ==3
      R2_method(1) = R2_method(1) + 1; 
   end   
   
   prev_answer = steamwork; %saves the previous correct answer
end

%% Plotting

figure(1)
bar(1:6,[R2_method./n.*100,random_method./n.*100,no_repeat_method./n.*100])
xticklabels({'3x R2', '1x R2', '3x random', '1x random', '3x no repeat', '1x no repeat'})
ylim([0,100]); ylabel('Percentage correct'); title(['n = ',num2str(n), ' iterations']);
