clear all
close all
clc

plots = 0;

data = readtable('SolarPrediction.csv');

%conversione fahrenheit in celsius
data{:,5} = (data{:,5} - 32) * 5/9;

%conversione Hg in atm
data{:,6} = data{:,6} / 29.921;

%conversione miglia in km
data{:,9} = data{:,9} * 1.60934;

%ri-mappatura orario
data{:,1} = mod(data{:,1}, 60 * 60 * 24);

%divisione in fasce orarie
n_timeslots = 8;
div_value = 60 * 60 * 24 / n_timeslots;
data{:,1} = ceil(data{:,1} / div_value);

%aggiungo due colonne con giorno e mese
data = [data array2table(day(data{:,2}), 'VariableNames', {'Day'}) ...
    array2table(month(data{:,2}), 'VariableNames', {'Month'})];

%tolgo Date, Time, TimeSunRise e TimeSunSet
data = data{:,[1 4 5 6 7 8 9 12 13]};

%suddivido i dataset per mese
september_data = data(find(data(:,9) == 9),:);
october_data = data(find(data(:,9) == 10),:);
november_data = data(find(data(:,9) == 11),:);
december_data = data(find(data(:,9) == 12),:);

%suddivido i precedenti dataset per giorno e ciascuno di quelli che trovo li
%suddivido per fascia oraria; effettuo la media di tutte le colonne e costruisco
%mano mano il dataset "mediato"
mean_september_data = [];
first_day_september = min(september_data(:,8));
last_day_september = max(september_data(:,8));
for j = 1:1:n_timeslots
    tmp_vec = [ ...
        j, %fascia oraria
        mean(september_data(find(september_data(:,1) == j),2)),
        mean(september_data(find(september_data(:,1) == j),3)),
        mean(september_data(find(september_data(:,1) == j),4)),
        mean(september_data(find(september_data(:,1) == j),5)),
        mean(september_data(find(september_data(:,1) == j),6)),
        mean(september_data(find(september_data(:,1) == j),7)),
        i, %giorno
        9 %mese
    ];
    mean_september_data = [mean_september_data; transpose(tmp_vec)];
end
mean_september_data = ...
    mean_september_data(sum(isnan(mean_september_data), 2) == 0,:);

mean_october_data = [];
first_day_october = min(october_data(:,8));
last_day_october = max(october_data(:,8));
for j = 1:1:n_timeslots
    tmp_vec = [ ...
        j, %fascia oraria
        mean(october_data(find(october_data(:,1) == j),2)),
        mean(october_data(find(october_data(:,1) == j),3)),
        mean(october_data(find(october_data(:,1) == j),4)),
        mean(october_data(find(october_data(:,1) == j),5)),
        mean(october_data(find(october_data(:,1) == j),6)),
        mean(october_data(find(october_data(:,1) == j),7)),
        i, %giorno
        9 %mese
    ];
    mean_october_data = [mean_october_data; transpose(tmp_vec)];
end
mean_october_data = ...
    mean_october_data(sum(isnan(mean_october_data), 2) == 0,:);

mean_november_data = [];
first_day_november = min(november_data(:,8));
last_day_november = max(november_data(:,8));
for j = 1:1:n_timeslots
    tmp_vec = [ ...
        j, %fascia oraria
        mean(november_data(find(november_data(:,1) == j),2)),
        mean(november_data(find(november_data(:,1) == j),3)),
        mean(november_data(find(november_data(:,1) == j),4)),
        mean(november_data(find(november_data(:,1) == j),5)),
        mean(november_data(find(november_data(:,1) == j),6)),
        mean(november_data(find(november_data(:,1) == j),7)),
        i, %giorno
        9 %mese
    ];
    mean_november_data = [mean_november_data; transpose(tmp_vec)];
end
mean_november_data = ...
    mean_november_data(sum(isnan(mean_november_data), 2) == 0,:);

mean_december_data = [];
first_day_december = min(december_data(:,8));
last_day_december = max(december_data(:,8));
for j = 1:1:n_timeslots
    tmp_vec = [ ...
        j, %fascia oraria
        mean(december_data(find(december_data(:,1) == j),2)),
        mean(december_data(find(december_data(:,1) == j),3)),
        mean(december_data(find(december_data(:,1) == j),4)),
        mean(december_data(find(december_data(:,1) == j),5)),
        mean(december_data(find(december_data(:,1) == j),6)),
        mean(december_data(find(december_data(:,1) == j),7)),
        i, %giorno
        9 %mese
    ];
    mean_december_data = [mean_december_data; transpose(tmp_vec)];
end
mean_december_data = ...
    mean_december_data(sum(isnan(mean_december_data), 2) == 0,:);

mean_dataset = [mean_september_data;
                mean_october_data;
                mean_november_data;
];

%percentuale del training set
perc = 70;
value = length(mean_dataset) * perc / 100;

%discretizzazione della colonna Y in n_levels valori
max_radiation_value = floor(max(mean_dataset(:,2))) + 1;
n_levels = 3;
xdata = mean_dataset(:,[1 3 4 5 6 7]);
ydata = mean_dataset(:,[2]);
sampled_ydata = ceil(ydata/ (max_radiation_value / n_levels));

%preparazione dataset per la PLS
xcols = [1 2 3 4 5 6];
%xcols = [1 2 4 5];

%normalizzazione 0 (no scaling), 1 (autoscaling), 2 (mean centering)
norm = 0;

training_set = xdata(1:floor(value), xcols);
test_set = xdata(floor(value)+1:length(xdata), xcols);

training_y = ydata(1:floor(value));
test_y = ydata(floor(value)+1:length(ydata));

%discretizzazione della colonna Y in n_levels valori
sampled_training_y = ceil(training_y / (max_radiation_value / n_levels));
sampled_test_y = ceil(test_y / (max_radiation_value / n_levels));

if plots == 1
    figure(1); hold on; title('Fascia oraria vs Radiation');
    plot(xdata(:,1), ydata, '*');
    hold off;
    figure(2); hold on; title('Temperatura vs Radiation');
    plot(xdata(:,2), ydata, '*');
    hold off;
    figure(3); hold on; title('Pressione vs Radiation');
    plot(xdata(:,3), ydata, '*');
    hold off;
    figure(4); hold on; title('Umidità vs Radiation');
    plot(xdata(:,4), ydata, '*');
    hold off;
    figure(5); hold on; title('Wind degrees vs Radiation');
    plot(xdata(:,5), ydata, '*');
    hold off;
    figure(6); hold on; title('Wind speed vs Radiation');
    plot(xdata(:,6), ydata, '*');
    hold off;
end
