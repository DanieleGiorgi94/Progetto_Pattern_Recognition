
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


X1 = int_pulse(1:2:end,1:10); % xdata in training
y = conc(1:2:end,:); % ydata in trainng

Xtest1=int_pulse(2:2:end,1:10); % xdata in test
ytest=conc(2:2:end,:); % ydata in test

% data normalization
% norm =1 autoscaling
% norm=2 mean centering
% norm=0 no scaling
%
norm=1;
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
end
 %
 
 %%
 % Analisi esplorativa dell'informazione delle singole features
 ff=3; % feature che vogliamo correlare con l'uscita
 % N = grado del polinomio con cui vogliamo determinare una possibile 
 %relazione tra la feature e l'uscita
  N=10;
  figure;

 plot(X(:,ff),y,'ro');
 % per plottare la info sul numero del campione nel grafico
 %plot_all([X(:,ff) y],[1 2 0 0 1]);
xlabel(['Feature n: ' num2str(ff)]);
ylabel('Ouput');

%% 
 
 
 
 % PLS
 
kk=10; % numero partizioni
n_LV=min([min(size(X)),40]); % numero max di LV

 % calcolo PLS
 % per cambiare il tipo di validazione guardare l'help della funzione
 % plsregress
  [XL,YL,XS,YS,BETA,PCTVAR,MSE0,STATS] = plsregress(X,y,n_LV); % MSE0 e' per il calcolo dell'errore in training

 [XL,YL,XS,YS,BETA,PCTVAR,MSE,STATS] = plsregress(X,y,n_LV,'CV',kk, 'MCReps',10); % per
 %
 %
 %Plot the percent of variance explained in the response variable as a function of the number of components.

figure;
plot(1:n_LV,cumsum(100*PCTVAR(2,:)),'-bo');
hold on;
plot(1:n_LV,cumsum(100*PCTVAR(1,:)),'-kd');

xlabel('Number of LV components');
ylabel('Explained Variance(%)');
legend(' Y','X');
title('Cumulative explained variance (%)');

% errore in cross validation
figure;
plot(0:n_LV,MSE0(2,:),'-rd');
hold on;
plot(0:n_LV,MSE(2,:),'-bo');
xlabel('Number of LV components');
ylabel('Mean squared Error');
legend(' Training','Cross Validation');
title(['Mean Square Error (MSE)' ]);


% plot dei residui
yfit = [ones(size(X,1),1) X]*BETA;
residuals = y - yfit;
ytestFitted = [ones(size(Xtest,1),1) Xtest]*BETA;
residuals_test=ytestFitted-ytest;




figure;
stem(residuals);
hold on;
stem(length(y)+1:length(y)+length(ytest),residuals_test)

hold on;
xlabel('Observation');
ylabel('Residual');
legend('Training','Test');
title( 'Residual plot');




% T2 vs Q
figure;
% plot T2 vs Q
%plot(residuals.^2,STATS.T2,'bo');
plot_all([residuals.^2 STATS.T2],[1 2 0 0 1]);
xlabel('Q');
ylabel('T^2');
title('T2 vs Q plot');

%%

%  predetto vs misurato
figure;
% plot of test data
plot(yfit,y,'rd');
hold on;
% plot predetto misurato dei dati di test
plot(ytestFitted ,ytest,'bs');

% plot predetto misurato dei dati di test 
% con indicazione del numero del campione
%plot_all([ytestFitted ,ytest],[1 2 0 0 1]);

rms_train=rms(yfit-y); % root mean square error in training
rms_test=rms(ytestFitted-ytest); % root mean square error in test
legend('Training','Test');

hold on;
aa=min(min(yfit),min(y));
bb=max(max(yfit),max(y));
line([aa bb],[aa bb]);
xlabel('Predicted');
ylabel('Measured');
title('predicted vs measured');
text(aa,bb,strcat({'RMSEC='},{num2str(rms_train)}));

%%

text(aa,bb*0.975,strcat({'RMSECV='},{num2str(rms_test)}));