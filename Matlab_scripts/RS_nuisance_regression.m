% Implementation of filtering and global signal regression in a single linear regression model

% The following variables should be defined in advance
% data = data (HbO or HbR) in the format time x channels
% sf = sampling frequency of the fNIRS system
% global_signal = mean signal across channels calculated on filtered data (HbO or HbR)
% Note that global signal will be different on each participant and for HbO and HbR
% lpf = Low-pass filter

% Load or define variables before running the script
% data =
% sf = 
% global_signal = 
% N = size(data_raw_wl1, 1); % if data organized as time x channels
% lpf =

% 1 – Create Legendre Polynomials (high-pass filter) % Compute length of the dataset (samples)
n_data = size(data,1);

% Compute length of the dataset (seconds)
s_data = n_data/sf;

% Calculate order of Legendre polynomials
k = 1 + floor(s_data/150);

% Create a basis set of Legendre polynomials (L)
n = linspace(-1,1,n_data)';
L = zeros(n_data,k+1);

for i = 1:k+1
  tmp = legendre(i-1,n);
  tmp = tmp(1,:);
L(:,i) = tmp/max(abs(tmp));  
end

% 2 - Create matrix of sines and cosines for all frequencies in the sf range
dft_matrix = dftmtx(n_data);

% Find index of the low-pass filter = frequency of interest
idx = floor((lpf/sf)*n_data);

% Select regressors of interest
dft_matrix_lpf = dft_matrix(idx:n_data-idx+1,:);

% Select sines and cosines
sin_lpf_mtx = imag(dft_matrix_lpf);
cos_lpf_mtx = real(dft_matrix_lpf);

% Matrix (time x frequency) of sines and cosines of frequencies above lpf
lpf_mtx = [cos_lpf_mtx' sin_lpf_mtx'];

% 3 - Compute nuissance regression (filter and global signal)
% Remember that the global signal for each participant should be calculated on
% filtered data to avoid reintroducing frequencies of non-interest
% Create matrix with regressors for filtering
reg_mat = [L lpf_mtx global_signal];
beta_data = pinv(reg_mat)*data;
data_filtered = data - reg_mat*beta_data;




