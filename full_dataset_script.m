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
cols = [1, 5, 6, 7, 8, 9];
xdata = data{:,cols};
%usiamo Radiation come colonna delle Y
ydata = data{:,4};

%discretizzazione della colonna Y in 4 valori
max_radiation_value = floor(max(ydata)) + 1;
n_levels = 4;
sampled_ydata = ceil(ydata / (max_radiation_value / n_levels));
