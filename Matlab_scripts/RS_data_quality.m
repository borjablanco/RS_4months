% Example script for fNIRS data quality assessment
% based on three data quality indicators
%
% Examples of the figures obtained with this script can be found at
% https://github.com/borjablanco/PhD_BorjaB/blob/main/Thesis_BB_final_lowres.pdf
% Appendix A

% Data quality assessment:
% 1 - TIME SERIES VISUALIZATION: visualize fNIRS time series (e.g., intensity and OD) of an individual participant.
% Two methods for data visualization are described 1) 2D line plots and 2) greyplots.

% 2 - POWER SPECTRAL DENSITY ASSESSMENT: Script to plot power spectral density of HbO and HbR.
% Three visualization methods are presented

% 3 -  3 - HbO-HbR STATISTICAL RELATIONSHIP_ Script to plot
% 1) HbO and HbR adjacency matrices (HbO, HbR, HbO-HbR) and
% 2) channelwise phase difference between HbO and HbR
% These metrics can also be computed after bandpass filtering HbO and HbR

% ################################# 1 - TIME SERIES VISUALIZATION
% The following variables should be defined in advance:
% Raw intensity and OD data for each wavelength in the format (time x channels)
% In this example: data_raw_wl1 and data_raw_wl2; data_OD_wl1 and data_OD_wl2
% N = number of samples/length of the dataset
% sf = sampling frequency

% Load or define variables before running the script
% data_raw_wl1 =
% data_raw_wl2 =
% data_OD_wl1 =
% data_OD_wl2 =
% N = size(data_raw_wl1, 1); % if data organized as time x channels
% sf =

% Create time vector (to display seconds instead of samples in plots)
t = (0:N-1)/sf;
% -------------------- Visualization method 1 – 2D line plots % Plot raw intensity time series
% Create figure
fig1 = figure; set(fig1, 'units', 'normalized', 'outerposition', [0 0 1 1], ...
    'Color', [1 1 1]);
set(0, 'DefaultAxesFontSize', 24, 'DefaultAxesTitleFontWeight', 'normal') 

% Plot raw intensity time series - wavelength 1
subplot(3,2,1)
plot(t, data_raw_wl1)
% Add titles, axes limits and axes labels
set(gca, 'YScale', 'log')
xlim([0 t(end)]); xlabel('Time (seconds)')
ylim([0 2.5]); ylabel('Intensity (log)'); title ('wl1 - 760 nm');

% Same steps for wavelength 2
subplot(3,2,2)
plot(t, data_raw_wl2)
set(gca, 'YScale', 'log')
xlim([0 t(end)]); xlabel('Time (seconds)')
ylim([0 2.5]); ylabel('Intensity (log)'); title ('wl2 - 850 nm');

% Plot OD time series - wavelength 1
subplot(3,2,3)
plot(t, data_OD_wl1)
xlim([0 t(end)]); xlabel('Time (seconds)')
ylim([-1.5 2]); ylabel('OD (A.U.)');

% Same steps for wavelength 2
subplot(3,2,4)
plot(t, data_OD_wl2)
xlim([0 t(end)]); xlabel('Time (seconds)')
ylim([-1.5 2]); ylabel('OD (A.U.)');

% -------------------- Visualization method 2 - Greyplots
subplot(3,2,5)
imagesc(data_OD_wl1', [-1 1])
xlabel('Time (samples)'); ylabel('Channel')
subplot(3,2,6)
imagesc(data_OD_wl2', [-1 1])
xlabel('Time (samples)'); ylabel('Channel')
colormap gray

% ######################## 2 - POWER SPECTRAL DENSITY ASSESSMENT
% The following variables should be defined in advance:
% data_HbO and data_HbR (can be calculated from OD data using hmrOD2Conc)
% N = number of samples/length of the dataset
% sf = sampling frequency (8.93Hz in this example)

% Load or define variables before running the script
% data_HbO =
% data_HbR =
% N = size(data_raw_wl1, 1); % if data organized as time x channels
% sf =

% Calculate frequency range
freq = linspace(0, sf/2, N/2+1);
% Compute Fourier Transform of HbO and HbR
fft_HbO = fft(data_HbO); % Fourier Transform HbO data
fft_HbO = 2*abs(fft_HbO(1:N/2+1, :)); % Keep only first half
fft_HbR = fft(data_HbR); % Fourier Transform HbR data
fft_HbR = 2*abs(fft_HbR(1:N/2+1, :)); % Keep only first half

% HbO
% Create figure
fig1 = figure; set(fig1, 'units', 'normalized', 'outerposition', [0 0 1 1], ...
    'Color', [1 1 1]);
set(0, 'DefaultAxesFontSize', 24, 'DefaultAxesTitleFontWeight', 'normal') 

% --------------- Visualization method 1 (mean HbR PSD across channels)
subplot(2,3,1)
plot(freq, mean(fft_HbO,2), 'r', 'linewidth', 1); box off
xlim([0 sf/2]); xlabel('Frequency (Hertz)');
ylim([0 800]); % adjust limits
title ('Mean PSD HbO')

% --------------- Visualization method 2 (mean PSD across channels ,log scale)
subplot(2,3,2)
plot(freq, mean(fft_HbO,2), 'r', 'linewidth', 1); box off
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log')
xlim([0 sf/2]); xlabel('Frequency (Hertz)')
title ('Mean PSD HbO (log scale)')

% Create XTickLabels for channel by channel plots
% Adjust labels based on sf (sf/2 = max)
freq_list = [0 ,1 ,2, 3, 4];
idx = zeros(1, length(freq_list));
for i = 1:length(freq_list)
    dist = abs(freq - freq_list(i));
    minDist = min(dist);
    idx(i) = find(dist == minDist);
    freq_labels = {'0', '1', '2', '3', '4'};
end

% --------------- Visualization method 3 (channel by channel plots)
subplot(2,3,3)
imagesc(fft_HbO', [0 100]) % adjust limits
set(gca, 'XTick', idx, 'XTickLabel', freq_labels)
xlabel('Frequency (Hertz)'); ylabel('Channels')
title ('PSD HbO (channel by channel)')
colormap jet; colorbar

% HbR
% --------------- Visualization method 1 (mean HbR PSD across channels)
subplot(2,3,4)
plot(freq, mean(fft_HbR,2), 'b', 'linewidth', 1); box off
xlim([0 sf/2]); xlabel('Frequency (Hertz)');
ylim([0 100]); % adjust limits
title ('Mean PSD HbR')

% --------------- Visualization method 2 (mean PSD across channels ,log scale)
subplot(2,3,5)
plot(freq, mean(fft_HbR,2), 'b', 'linewidth', 1); box off
set(gca, 'XScale', 'log'); set(gca, 'YScale', 'log')
xlim([0 sf/2]); xlabel('Frequency (Hertz)')
title ('Mean PSD HbR (log scale)')

% --------------- Visualization method 3 (channel by channel plots)
subplot(2,3,6)
imagesc(fft_HbR', [0 20]) % adjust limits
xlabel('Frequency (Hertz)'); ylabel('Channels')
set(gca, 'XTick', idx, 'XTickLabel', freq_labels)
title ('PSD HbR (channel by channel)')
colormap jet; colorbar

% ######################## 3 - HbO-HbR STATISTICAL RELATIONSHIP
% The following variables should be defined in advance:
% data_HbO and data_HbR (raw HbO and HbR concentration data)
% ch = number of channels of the dataset

% Load or define variables before running the script
% data_HbO =
% data_HbR =
% ch = size(data_HbO, 2); % if data organized as time x channels

% Create figure
fig1 = figure; set(fig1, 'units', 'normalized', 'outerposition', [0 0 1 1], ...
    'Color', [1 1 1]);
set(0, 'DefaultAxesFontSize', 24, 'DefaultAxesTitleFontWeight', 'normal') 

% Compute and plot adjacency matrices
subplot(1,4,1)
imagesc(corr(data_HbO), [-1 1]); colorbar
xlabel('Channels'); ylabel({'Raw data'; 'Channels'})
title('HbO'); axis square

subplot(1,4,2)
imagesc(corr(data_HbR), [-1 1]); colorbar
xlabel('Channels');
title('HbR'); axis square

subplot(1,4,3)
imagesc(corr(data_HbO, data_HbR), [-1 1]); colorbar
xlabel('Channels');
title('HbO-HbR'); axis square
colormap jet

% Compute hPod value (HbO-HbR phase difference as described in Watanabe et al., 2017)
hPod = zeros(1, ch);
for nch = 1:ch
    
    % Calculate Hilbert transformation of the signals
    HbO_hilbert = hilbert(data_HbO(:, nch));
    HbR_hilbert = hilbert(data_HbR(:, nch));
    
    % Calculate instantaneous phase
    HbO_inst = unwrap(angle(HbO_hilbert));
    HbR_inst = unwrap(angle(HbR_hilbert));
    
    % Calculate phase difference
    ph_dif = HbO_inst - HbR_inst;
    
    % Compute and store hPod
    hPod (nch) = angle(mean(exp(sqrt(-1)*ph_dif)));
end

% Plot hpod
subplot(1,4,4)
h = polarhistogram (hPod, 10); % adjust number of bins
set(h, 'linewidth', 1, 'FaceColor', 'b')
title('Phase difference HbO-HbR (degrees)')

