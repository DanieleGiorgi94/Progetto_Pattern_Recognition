clear all
close all
clc

data = readtable('SolarPrediction.csv');

%conversione fahrenheit in celsius
data{:,5} = (data{:,5} - 32) * 5/9;

%eliminazione colonna UNIXTime
data.UNIXTime = [];
head(data, height(data));

%conversione Hg in atm
data{:,5} = data{:,5} / 29.921;

%conversione miglia in km
data{:,8} = data{:,8} * 1.60934;

%divisione del dataset in train (90%) e test (10%)
row_train = 29417;
% fprintf('%.0f\n',height(data)*90/100) = 29417
train = data(1:row_train, :);
test = data(row_train+1:height(data),:);


