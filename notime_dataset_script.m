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

%togliamo Date, Time, Radiation, TimeSunRise e TimeSunSet per la matrice X
cols = [5, 6, 7, 8, 9];
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
three_features = 0;
humidity_out = 1;

%normalizzazione 0 (no scaling), 1 (autoscaling), 2 (mean centering)
norm = 1;

if all_features == 1
    training_set = xdata(1:floor(value),:);
    test_set = xdata(floor(value)+1:length(xdata),:);
end
if three_features == 1
    training_set = xdata(1:floor(value),[1 3 4]);
    test_set = xdata(floor(value)+1:length(xdata),[1 3 4]);
end
if humidity_out == 1
    training_set = xdata(1:floor(value),[1 3 4 5]);
    test_set = xdata(floor(value)+1:length(xdata),[1 3 4 5]);
end

test_y = ydata(floor(value)+1:length(ydata),:);
training_y = ydata(1:floor(value));
