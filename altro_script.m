%clear all
%close all
%clc
%
%%%
%e= @(k,n) [zeros(k-1,1);1;zeros(n-k,1)];
%
%%%
%data = readtable('SolarPrediction.csv');
%n_timeslots = 4;
%
%%conversione fahrenheit in celsius
%data{:,5} = (data{:,5} - 32) * 5/9;
%
%%conversione Hg in atm
%data{:,6} = data{:,6} / 29.921;
%
%%conversione miglia in km
%data{:,9} = data{:,9} * 1.60934;
%
%%ri-mappatura orario
%data{:,1} = mod(data{:,1}, 60 * 60 * 24);
%
%%aggiungo quattro colonne con le fasce orarie 
%morning = zeros(height(data),1);
%afternoon = zeros(height(data),1);
%evening = zeros(height(data),1);
%night = zeros(height(data),1);
%
%data = [data array2table(morning, 'VariableNames', {'Morning'}) ...
%    array2table(afternoon, 'VariableNames', {'Afternoon'}) ...   
%    array2table(evening, 'VariableNames', {'Evening'}) ...
%    array2table(night, 'VariableNames', {'Night'})];
%
%%divisione in fasce orarie
%n_timeslots = 4;
%%div_value = 60 * 60 * 24 / n_timeslots;
%%data{:,1} = ceil(data{:,1} / div_value);
%for j = 1:height(data)
%    t = data{j,1};
%    if (t >= 79201 && t <= 86400)|| (t >= 0 && t <= 18000)
%        data{j,13} = 1; % afternoon (h. 12-19)
%        data{j,1} = 2;
%    elseif t >= 18001 && t <= 36000
%        data{j,14} = 1; % evening (h. 19-24)
%        data{j,1} = 3; 
%    elseif t >= 36001 && t <= 57600
%        data{j,15} = 1; % night (h. 0-6)
%        data{j,1} = 4;
%    elseif t >= 57601 && t <= 79200 
%        data{j,12} = 1; % morning (h. 6-12)   
%        data{j,1} = 1;
%    end
%end
%
%%%
%%aggiungo due colonne con giorno e mese
%data = [data array2table(day(data{:,2}), 'VariableNames', {'Day'}) ...
%    array2table(month(data{:,2}), 'VariableNames', {'Month'})];
%
%%tolgo Date, Time, TimeSunRise e TimeSunSet
%data = data{:,[1 4 5 6 7 8 9 12 13 14 15 16 17]};
%
%%suddivido i dataset per mese
%september_data = data(find(data(:,13) == 9),:);
%october_data = data(find(data(:,13) == 10),:);
%november_data = data(find(data(:,13) == 11),:);
%december_data = data(find(data(:,13) == 12),:);
%
%%%
%%suddivido i precedenti dataset per giorno e ciascuno di quelli che trovo li
%%suddivido per fascia oraria; effettuo la media di tutte le colonne e costruisco
%%mano mano il dataset "mediato"
%mean_september_data = [];
%first_day_september = min(september_data(:,12));
%last_day_september = max(september_data(:,12));
%for i = first_day_september:1:last_day_september
%    tmp_subdataset = september_data(find(september_data(:,12) == i),:);
%    for j = 1:1:n_timeslots
%        e_vec = e(j, 4);
%        tmp_vec = [ ...
%            j, %fascia oraria
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),2)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),3)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),4)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),5)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),6)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),7)),
%            i, %giorno
%            9, %mese
%            e_vec(1),
%            e_vec(2),
%            e_vec(3),
%            e_vec(4)
%        ];
%        mean_september_data = [mean_september_data; transpose(tmp_vec)];
%    end
%end
%mean_september_data = ...
%    mean_september_data(sum(isnan(mean_september_data), 2) == 0,:);
%
%mean_october_data = [];
%first_day_october = min(october_data(:,12));
%last_day_october = max(october_data(:,12));
%for i = first_day_october:1:last_day_october
%    tmp_subdataset = october_data(find(october_data(:,12) == i),:);
%    for j = 1:1:n_timeslots
%        e_vec = e(j, 4);
%        tmp_vec = [ ...
%            j, %fascia oraria
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),2)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),3)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),4)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),5)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),6)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),7)),
%            i, %giorno
%            10, %mese
%            e_vec(1),
%            e_vec(2),
%            e_vec(3),
%            e_vec(4)
%        ];
%        mean_october_data = [mean_october_data; transpose(tmp_vec)];
%    end
%end
%mean_october_data = ...
%    mean_october_data(sum(isnan(mean_october_data), 2) == 0,:);
%
%mean_november_data = [];
%first_day_november = min(november_data(:,12));
%last_day_november = max(november_data(:,12));
%for i = first_day_november:1:last_day_november
%    tmp_subdataset = november_data(find(november_data(:,12) == i),:);
%    for j = 1:1:n_timeslots
%        e_vec = e(j, 4);
%        tmp_vec = [ ...
%            j, %fascia oraria
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),2)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),3)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),4)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),5)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),6)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),7)),
%            i, %giorno
%            11, %mese
%            e_vec(1),
%            e_vec(2),
%            e_vec(3),
%            e_vec(4)
%        ];
%        mean_november_data = [mean_november_data; transpose(tmp_vec)];
%    end
%end
%mean_november_data = ...
%    mean_november_data(sum(isnan(mean_november_data), 2) == 0,:);
%
%mean_december_data = [];
%first_day_december = min(december_data(:,12));
%last_day_december = max(december_data(:,12));
%for i = first_day_december:1:last_day_december
%    tmp_subdataset = december_data(find(december_data(:,12) == i),:);
%    for j = 1:1:n_timeslots
%        e_vec = e(j, 4);
%        tmp_vec = [ ...
%            j, %fascia oraria
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),2)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),3)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),4)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),5)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),6)),
%            mean(tmp_subdataset(find(tmp_subdataset(:,1) == j),7)),
%            i, %giorno
%            12, %mese
%            e_vec(1),
%            e_vec(2),
%            e_vec(3),
%            e_vec(4)
%        ];
%        mean_december_data = [mean_december_data; transpose(tmp_vec)];
%    end
%end
%mean_december_data = ...
%    mean_december_data(sum(isnan(mean_december_data), 2) == 0,:);
%
%mean_dataset = [mean_september_data; mean_december_data; mean_november_data; ...
%    mean_october_data];
%
%%%
%%togliamo Date, Time, Radiation, TimeSunRise e TimeSunSet per la matrice X
%cols = [3, 4, 5, 6, 7, 10, 11, 12, 13];
%
%%percentuale del training set
%perc = 70;
%value = length(mean_dataset) * perc / 100;
%
%xdata = mean_dataset(:,cols);
%ydata = mean_dataset(:,[2]);
%
%%%discretizzazione della colonna Y in 4 valori
%max_radiation_value = floor(max(ydata)) + 1;
%n_levels = 3;
%sampled_ydata = ceil(ydata / (max_radiation_value / n_levels));
%
%%
xcols = [1 2 3 4 5 6 7 8 9];
training_set = xdata(1:floor(value), xcols);
test_set = xdata(floor(value)+1:length(xdata), xcols);

training_y = ydata(1:floor(value));
test_y = ydata(floor(value)+1:length(ydata));

sampled_training_y = ceil(training_y / (max_radiation_value / n_levels));
sampled_test_y = ceil(test_y / (max_radiation_value / n_levels));

%normalizzazione 0 (no scaling), 1 (autoscaling), 2 (mean centering)
norm = 2;
