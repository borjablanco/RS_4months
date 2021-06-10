% #######################################
% THIS SCRIPT IS NOT FINISHED
% #######################################

% Script to convert from .nirs to .snirf
% to load RS4 data from https://osf.io/7fzkm/
% using Homer3 functions https://github.com/BUNPC/Homer3

% Add path Homer3
addpath(genpath('/Users/borjablanco/Documents/MATLAB/toolboxes/Homer3-master'))

% Convert all files in a folder
rsdataset = Nirs2Snirf('/Users/borjablanco/Nextcloud/RS_DATASET/data_nirs');

% Or one by one
sub = dir('*.nirs');

for nsub = 1:lenght(sub)
    Nirs2Snirf('/Users/borjablanco/Nextcloud/RS_DATASET/data_nirs', ['/Users/borjablanco/Nextcloud/RS_DATASET/data_nirs/' sub(nsub).name])
end

% snirf won't accept structures, it needs variables
% Use below to save a data structure to .nirs format
save('prueba.nirs', '-struct', 'data')

% IT ONLY SAVES SOME FIELDS, HOW TO ADD MORE FIELDS AND INFORMATION?

% To load snirf files into the workspace
snirf2 = SnirfClass();
snirf2.Load('RS4_SL_4216.snirf');
snirf2.Info()


% TESTS
data = load('prueba.nirs', '-mat');



