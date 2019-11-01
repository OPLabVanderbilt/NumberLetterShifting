%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Processing Shifting Data
%% NOTE!!! Don't forget to delete the header line from the textfile!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
files = dir('NumberLetterShifting_Data/*.txt');
outfile1 = fopen('Shifting_Processed_Data.txt', 'w');

for q = 1:size(files, 1)
    %delete the header line from the textfile so this line can run!
    [subjno subjini age sex blkno m trialtype task repeat letnumorder lettype letter numtype number corrans resp ac rt] = textread (['NumberLetterShifting_Data/' char(files(q).name)], '%s %s %s %s %d %d %s %s %s %s %s %s %s %s %d %d %d %f');
    
    ntrialsRepeat = 0;
    ntrialsSwitch = 0;
    sum_Repeat_RT = 0;
    sum_Switch_RT = 0;
    
    for k = 1:size(subjno, 1)
        if strcmp(trialtype{k}, 'test') %exclude the warmup trials
            if strcmp(repeat{k}, 'repeat') %if it's a repeat trial
                ntrialsRepeat = ntrialsRepeat + 1; %count num of repeat trials
                sum_Repeat_RT = sum_Repeat_RT + rt(k); %sums the RTs of repeat trials
            elseif strcmp(repeat{k}, 'switch') %if it's a repeat trial
                ntrialsSwitch = ntrialsSwitch + 1; %count num of switch trials
                sum_Switch_RT = sum_Switch_RT + rt(k); %sums the RTs of switch trials
            end
        elseif strcmp(trialtype{k}, 'warmup')
            %do nothing
        end
    end
    
    
    %calculate mean RT
    mean_rt_repeat = sum_Repeat_RT/ntrialsRepeat;
    mean_rt_switch = sum_Switch_RT/ntrialsSwitch;
    switch_cost = mean_rt_switch - mean_rt_repeat;
    
    fprintf(outfile1, '%s\t%f\t%f\t%f\n', subjno{1}, mean_rt_repeat, mean_rt_switch, switch_cost);
end

