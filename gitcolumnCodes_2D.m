function E = gitcolumnCodes_2D
% shared columnCodes with Ashkan

E.monkeyID = 1; 

E.unitID = 2; 
% DATE.DEPTH i.e. yyyymmdd.xxxxx micrometers
% DATE.TIME for array recordings. Time is the start recording time of file

E.fileID = 3; 

E.object_in_RF = 4;

E.trial_type = 5;
% Info in plxCodes 

E.dot_diam = 6;
E.motionCoherence = 7;
E.motion_dir = 8;
E.target1_x = 9;
E.target1_y = 10;
E.target2_x = 11;
E.target2_y = 12;
E.dot_duration = 13;
% Also the computer chosen go-time on saccade tasks

E.fixation_x = 14;
E.fixation_y = 15;
E.dots_x = 16;
E.dots_y = 17;
E.dot_speed = 18;

E.pct_novar = 19;
E.seedvar = 20;
E.seed = 21;
E.flicker = 22;

E.time_FP_on = 23;
E.time_fix_acq = 24;
E.time_target_on = 25;
E.time_target_off = 26;
E.time_dots_on = 27;
E.time_dots_off = 28;
E.time_FP_off = 29;
E.time_saccade = 30;
E.time_targ_acq = 31;
E.time_reward = 32;
E.time_end = 33;

E.target_choice = 34;
E.correct_target = 35;
% In saccade tasks, ID of the target in the trial

E.isCorrect = 36; % both! 
E.react_time = 37;
E.eye_trl_class = 38;
E.eye_t_sac = 39;
E.eye_rt = 40;
E.RF_x = 41;
E.RF_y = 42;

E.time_target1_on = 43; % For asynchronous target paradigms
E.time_target2_on = 44; % For asynchronous target paradigms
E.offset_frame_target1and2 = 45; % For asynchronous target paradigms
E.target_asynchrony = 46; % For asynchronous target paradigms

E.time_since_previous_trial=47;

E.reward_size = 48;
E.reward_prize = 49; 

% column codes added for 2D paradigm
E.reward_half = 50; % if only color OR motion is correct
E.dot_size = 51; % size of individual dots

E.colorCoherence = 52;
E.color_dir = 53;

E.target3_x = 54;
E.target3_y = 55;
E.target4_x = 56;
E.target4_y = 57;

E.target_chosen_location = 58; % chosen target location (1=bottom right, 2=bottom left, 3=top right, 4=top left)

E.monitorDist = 59;

% fixation info
E.fix_size = 60;
E.fix_R = 61;
E.fix_G = 62;
E.fix_B = 63;
% to initiate the trial:
E.fix_acceptance_window_sizeX_start = 64;
E.fix_acceptance_window_sizeY_start = 65;
% to get through the rest of the trial:
E.fix_acceptance_window_sizeX_trial = 66;
E.fix_acceptance_window_sizeY_trial = 67;

% lums and RGBs
E.target1_Size = 68;
E.target1_R = 69;
E.target1_G = 70;
E.target1_B = 71;

E.target2_Size = 72;
E.target2_R = 73;
E.target2_G = 74;
E.target2_B = 75;

E.target3_Size = 76;
E.target3_R = 77;
E.target3_G = 78;
E.target3_B = 79;

E.target4_Size = 80;
E.target4_R = 81;
E.target4_G = 82;
E.target4_B = 83;

E.target_acceptance_window_sizeX = 84;
E.target_acceptance_window_sizeY = 85;

E.target_chosen_window = 86; % chosen target window (3=correct, 4=wrong motion, 5=wrong color, 6=wrong both)

E.signedMotionCoherence = 87;
E.signedColorCoherence  = 88; 
E.rightwardChoice  = 89;
E.upChoice         = 90;
E.isCorrect_motion = 91; % ignoring color accuracy
E.isCorrect_color  = 92; % ignoring motion accuracy

