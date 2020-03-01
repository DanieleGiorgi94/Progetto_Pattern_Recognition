clc
clear all
%%
% inizializzazione
clear X
clear y
clear MU
clear SIGMA
clear Xtest
clear Xtest1
clear ytestFitted
clear ytest
clear yfit

%xdata in training
X1 = training_set;
%ydata in training
y = training_y;

%xdata in test
Xtest1 = test_set;
%ydata in test
ytest = test_y;

%data normalization
%norm =1 autoscaling
%norm=2 mean centering
%norm=0 no scaling
if norm==1
    [X,MU,SIGMA] = zscore(X1);
     for i=1:length(Xtest1(:,1))
      Xtest(i,:)=(Xtest1(i,:)-MU)./SIGMA;
     end
elseif norm==2 
     [AA,MU,SIGMA] = zscore(X1);
     for i=1:length(X1(:,1))
      X(i,:)=(X1(i,:)-MU);
     end
   
     for i=1:length(Xtest1(:,1))
      Xtest(i,:)=(Xtest1(i,:)-MU);
     end
elseif norm == 0
    Xtest = Xtest1;
    X = X1;
end

% 
% PLS

rms_test_min = 1000000;
rms_test_index = 0;

min_vec = [];
min_rmsecv = [];

while length(min_vec) < 9

for i = 1:9
if ( ~ismember(i,min_vec))
    X_t = X(:,[min_vec i]);
    Xtest_t = Xtest(:,[min_vec i]);
else
    continue;
end

% numero partizioni
kk=10;
% numero max di LV
n_LV=min([min(size(X_t)),5]);

% calcolo PLS
% per cambiare il tipo di validazione guardare l'help della funzione plsregress
[XL,YL,XS,YS,BETA,PCTVAR,MSE0,STATS] = plsregress(X_t,y,n_LV);
%MSE0 e' per il calcolo dell'errore in training
[XL,YL,XS,YS,BETA,PCTVAR,MSE,STATS] = plsregress(X_t,y,n_LV,'CV',kk, 'MCReps',10);


yfit = [ones(size(X,1),1) X_t]*BETA;
residuals = y - yfit;
ytestFitted = [ones(size(Xtest_t,1),1) Xtest_t]*BETA;
residuals_test=ytestFitted-ytest;

%
% plot predetto misurato dei dati di test 
% con indicazione del numero del campione
%plot_all([ytestFitted ,ytest],[1 2 0 0 1]);

rms_train=sqrt(sum((yfit-y).^2)/length(yfit)); % root mean square error in training
rms_test=sqrt(sum((ytestFitted-ytest).^2)/length(yfit)); % root mean square error in test

if rms_test < rms_test_min
    rms_test_min = rms_test;
    rms_test_index = i;
end

end

min_vec = [min_vec rms_test_index];
min_rmsecv = [min_rmsecv rms_test_min];

rms_test_min = 100000;
rms_test_index = 0;

end

%%clc
clear all
%% Feature selection discendent 
% inizializzazione
clear X
clear y
clear MU
clear SIGMA
clear Xtest
clear Xtest1
clear ytestFitted
clear ytest
clear yfit

%xdata in training
X1 = training_set;
%ydata in training
y = training_y;

%xdata in test
Xtest1 = test_set;
%ydata in test
ytest = test_y;

%data normalization
%norm =1 autoscaling
%norm=2 mean centering
%norm=0 no scaling
if norm==1
    [X,MU,SIGMA] = zscore(X1);
     for i=1:length(Xtest1(:,1))
      Xtest(i,:)=(Xtest1(i,:)-MU)./SIGMA;
     end
elseif norm==2 
     [AA,MU,SIGMA] = zscore(X1);
     for i=1:length(X1(:,1))
      X(i,:)=(X1(i,:)-MU);
     end
   
     for i=1:length(Xtest1(:,1))
      Xtest(i,:)=(Xtest1(i,:)-MU);
     end
elseif norm == 0
    Xtest = Xtest1;
    X = X1;
end

% 
% PLS

rms_test_min = 1000000;
rms_test_vec = [];

min_vec = [1 2 3 4 5 6 7 8 9];
min_rmsecv = [];

while length(min_vec) > 1

for i = 1:length(min_vec)
   
    min_vec_t = min_vec;
    min_vec_t(:, i) = [];
    
    X_t = X(:, min_vec_t);   
    Xtest_t = Xtest(:, min_vec_t);
    
    disp(i);

% numero partizioni
kk=10;
% numero max di LV
n_LV=min([min(size(X_t)),5]);

% calcolo PLS
% per cambiare il tipo di validazione guardare l'help della funzione plsregress
[XL,YL,XS,YS,BETA,PCTVAR,MSE0,STATS] = plsregress(X_t,y,n_LV);
%MSE0 e' per il calcolo dell'errore in training
[XL,YL,XS,YS,BETA,PCTVAR,MSE,STATS] = plsregress(X_t,y,n_LV,'CV',kk, 'MCReps',10);


yfit = [ones(size(X,1),1) X_t]*BETA;
residuals = y - yfit;
ytestFitted = [ones(size(Xtest_t,1),1) Xtest_t]*BETA;
residuals_test=ytestFitted-ytest;

%
% plot predetto misurato dei dati di test 
% con indicazione del numero del campione
%plot_all([ytestFitted ,ytest],[1 2 0 0 1]);

rms_train=sqrt(sum((yfit-y).^2)/length(yfit)); % root mean square error in training
rms_test=sqrt(sum((ytestFitted-ytest).^2)/length(yfit)); % root mean square error in test

if rms_test < rms_test_min
    rms_test_min = rms_test;
    rms_test_vec = min_vec_t;
end

end

min_rmsecv = [min_rmsecv rms_test_min];

rms_test_min = 100000;
min_vec = rms_test_vec;

end







