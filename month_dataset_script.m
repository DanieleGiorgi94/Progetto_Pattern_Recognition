clear all
close all
clc

grafici = 0;

data = readtable('SolarPrediction.csv');

%conversione fahrenheit in celsius
data{:,5} = (data{:,5} - 32) * 5/9;

%conversione Hg in atm
data{:,6} = data{:,6} / 29.921;

%conversione miglia in km
data{:,9} = data{:,9} * 1.60934;

%ri-mappatura orario
data{:,1} = mod(data{:,1}, 60 * 60 * 24);

september_data = data(1:7417,:);
october_data = data(7418:16238,:);
november_data = data(16239:24522,:);
december_data = data(24523:32686,:);

%togliamo Date, Time, Radiation, TimeSunRise e TimeSunSet per la matrice X
%usiamo Radiation come colonna delle Y
cols = [1, 5, 6, 7, 8, 9];
n_levels = 4;

x_september_data = september_data{:,cols};
y_september_data = september_data{:,4};
%discretizzazione della colonna Y in n_levels valori
max_radiation_value = floor(max(y_september_data)) + 1;
sampled_y_september_data = ...
    ceil(y_september_data / (max_radiation_value / n_levels));

x_october_data = october_data{:,cols};
y_october_data = october_data{:,4};
%discretizzazione della colonna Y in 4 valori
max_radiation_value = floor(max(y_october_data)) + 1;
sampled_y_october_data = ...
    ceil(y_october_data / (max_radiation_value / n_levels));

x_november_data = november_data{:,cols};
y_november_data = november_data{:,4};
%discretizzazione della colonna Y in 4 valori
max_radiation_value = floor(max(y_november_data)) + 1;
sampled_y_november_data = ...
    ceil(y_november_data / (max_radiation_value / n_levels));

x_december_data = december_data{:,cols};
y_december_data = december_data{:,4};
%discretizzazione della colonna Y in 4 valori
max_radiation_value = floor(max(y_december_data)) + 1;
sampled_y_december_data = ...
    ceil(y_december_data / (max_radiation_value / n_levels));

%%%----------------------GRAFICI DI SETTEMBRE-------------------------------
if grafici == 1
figure(1); hold on;
title('UNIXTime vs Radiation');
plot(x_september_data(:,1), y_september_data, '*');
plot(x_september_data(:,1), sampled_y_september_data * 100, ...
's', 'MarkerSize', 10, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', [1 .6 .6]);
hold off;

figure(2); hold on;
title('Temperature vs Radiation');
plot(x_september_data(:,2), y_september_data, '*');
plot(x_september_data(:,2), sampled_y_september_data * 100, ...
's', 'MarkerSize', 10, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', [1 .6 .6]);
hold off;

figure(3); hold on;
title('Pressure vs Radiation');
plot(x_september_data(:,3), y_september_data, '*');
plot(x_september_data(:,3), sampled_y_september_data * 100, ...
's', 'MarkerSize', 10, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', [1 .6 .6]);
hold off;

figure(4); hold on;
title('Humidity vs Radiation');
plot(x_september_data(:,4), y_september_data, '*');
plot(x_september_data(:,4), sampled_y_september_data * 100, ...
's', 'MarkerSize', 10, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', [1 .6 .6]);
hold off;

figure(5); hold on;
title('Wind degrees vs Radiation');
plot(x_september_data(:,5), y_september_data, '*');
plot(x_september_data(:,5), sampled_y_september_data * 100, ...
's', 'MarkerSize', 10, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', [1 .6 .6]);
hold off;

figure(6); hold on;
title('Wind speed vs Radiation');
plot(x_september_data(:,6), y_september_data, '*');
plot(x_september_data(:,6), sampled_y_september_data * 100, ...
's', 'MarkerSize', 10, 'MarkerEdgeColor', 'red', 'MarkerFaceColor', [1 .6 .6]);
hold off;
end
%%%-------------------------------------------------------------------------

%percentuale del training set
perc = 70;
value = length(x_september_data) * perc / 100;

%normalizzazione 0 (no scaling), 1 (autoscaling), 2 (mean centering)
norm = 0;

all_features = 0;
four_features = 1;

if all_features == 1
    training_set = x_september_data(1:floor(value),:);
    test_set = x_september_data(floor(value)+1:length(x_september_data),:);
end
if four_features == 1
    training_set = x_september_data(1:floor(value),[1 2 4 5]);
    test_set = ...
        x_september_data(floor(value)+1:length(x_september_data),[1 2 4 5]);
end
training_y = y_september_data(1:floor(value));
test_y = y_september_data(floor(value)+1:length(y_september_data),:);
