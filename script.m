clear all
close all
clc

data = readtable('SolarPrediction.csv');

%conversione fahrenheit a celsius
data{:,5} = (data{:,5} - 32) * 5/9;

%eliminazione colonna UNIXTime
data.UNIXTime = [];
head(data, height(data));

%conversione Hg in atm
data{:,5} = data{:,5} / 29.921;

%conversione miglia in km
data{:,8} = data{:,8} * 1.60934;
