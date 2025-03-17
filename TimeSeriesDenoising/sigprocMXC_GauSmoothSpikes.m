%%
%     COURSE: Signal processing problems, solved in MATLAB and Python
%    SECTION: Time-domain denoising
%      VIDEO: Gaussian-smooth a spike time series
% Instructor: sincxpress.com
%
%%

%% generate time series of random spikes

% number of spikes
n = 300;

% inter-spike intervals (exponential distribution for bursts)
isi = round(exp(randn(n,1)) * 10);

% generate spike time series
% matlab doesn't allow spikets = 0 anymore
maxtime = sum(isi); % Maximum possible length
spikets = zeros(maxtime, 1); % Preallocate the spike time series

% Generate spike time series safely
currentIndex = 1;
for i = 1:n
    currentIndex = currentIndex + isi(i);
    if currentIndex <= maxtime
        spikets(currentIndex) = 1;
    end
end

% plot
figure(1), clf, hold on

h = plot(spikets);
set(gca, 'ylim', [0 1.01], 'xlim', [0 length(spikets)+1])
set(h, 'color', [1 1 1] * .7)
xlabel('Time (a.u.)')

%% create and implement Gaussian window

% full-width half-maximum: the key Gaussian parameter
fwhm = 25; % in points

% normalized time vector in ms
k = 100;
gtime = -k:k;

% create Gaussian window
gauswin = exp(-(4 * log(2) * gtime.^2) / fwhm^2);
gauswin = gauswin / sum(gauswin);

% initialize filtered signal vector
filtsigG = zeros(size(spikets));

% implement the weighted running mean filter
    % had to revise bc it was throwing an out of bounds error
for i = k+1 : length(spikets)-k
    filtsigG(i) = sum(spikets(i-k:i+k) .* gauswin(:)); % Ensure correct shape
end

% plot the filtered signal (spike probability density)
plot(filtsigG, 'r', 'linew', 2)
legend({'Spikes', 'Spike p.d.'})
title('Spikes and spike probability density')
zoom on

%% done.
