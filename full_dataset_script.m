clear all
close all
clc

data = readtable('SolarPrediction.csv');

%conversione fahrenheit in celsius
data{:,5} = (data{:,5} - 32) * 5/9;

%conversione Hg in atm
data{:,6} = data{:,6} / 29.921;

%conversione miglia in km
data{:,9} = data{:,9} * 1.60934;

%ri-mappatura orario
data{:,1} = mod(data{:,1}, 60 * 60 * 24);

%togliamo Date, Time, Radiation, TimeSunRise e TimeSunSet per la matrice X
cols = [1, 5, 6, 7, 8, 9];
xdata = data{:,cols};
%usiamo Radiation come colonna delle Y
ydata = data{:,4};

%discretizzazione della colonna Y in 4 valori
max_radiation_value = floor(max(ydata)) + 1;
n_levels = 4;
sampled_ydata = ceil(ydata / (max_radiation_value / n_levels));

%percentuale del training set
perc = 70;
value = height(data) * perc / 100;

%preparazione dataset per la PLS
all_features = 0;
only_time = 0;
time_winddegrees_temperature = 1;

training_set = xdata(1:floor(value),:);
test_set = xdata(floor(value)+1:length(xdata),:);
training_y = ydata(1:floor(value));
test_y = ydata(floor(value)+1:length(ydata),:);

nnet_training_set = transpose(training_set);
nnet_test_set = transpose(test_set);
nnet_training_y = transpose(training_y);
nnet_test_y = transpose(test_y);
