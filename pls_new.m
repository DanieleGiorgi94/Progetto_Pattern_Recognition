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

resid = 1;
t2 = 0;

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

%%
% Analisi esplorativa dell'informazione delle singole features
ff=length(X(1,:)); % feature che vogliamo correlare con l'uscita
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

% numero partizioni
kk=10;
% numero max di LV
n_LV=min([min(size(X)),4]);

% calcolo PLS
% per cambiare il tipo di validazione guardare l'help della funzione plsregress
[XL,YL,XS,YS,BETA,PCTVAR,MSE0,STATS] = plsregress(X,y,n_LV);
%MSE0 e' per il calcolo dell'errore in training
[XL,YL,XS,YS,BETA,PCTVAR,MSE,STATS] = plsregress(X,y,n_LV,'CV',kk, 'MCReps',10);

%Plot the percent of variance explained in the response variable as a function
%of the number of components.
figure;
plot(1:n_LV,cumsum(100*PCTVAR(2,:)),'-bo');
hold on;
plot(1:n_LV,cumsum(100*PCTVAR(1,:)),'-kd');
xlabel('Number of LV components');
ylabel('Explained Variance(%)');
legend(' Y','X');
title('Cumulative explained variance (%)');

%errore in cross validation
figure;
plot(0:n_LV,MSE0(2,:),'-rd');
hold on;
plot(0:n_LV,MSE(2,:),'-bo');
xlabel('Number of LV components');
ylabel('Mean squared Error');
legend(' Training','Cross Validation');
title(['Mean Square Error (MSE)' ]);

yfit = [ones(size(X,1),1) X]*BETA;
residuals = y - yfit;
ytestFitted = [ones(size(Xtest,1),1) Xtest]*BETA;
residuals_test=ytestFitted-ytest;

if resid == 1
    %plot dei residui
    figure;
    stem(residuals);
    hold on;
    stem(length(y)+1:length(y)+length(ytest),residuals_test)
    
    hold on;
    xlabel('Observation');
    ylabel('Residual');
    legend('Training','Test');
    title( 'Residual plot');
end
if t2 == 1
    % T2 vs Q
    figure;
    % plot T2 vs Q
    %plot(residuals.^2,STATS.T2,'bo');
    plot_all([residuals.^2 STATS.T2],[1 2 0 0 1]);
    xlabel('Q');
    ylabel('T^2');
    title('T2 vs Q plot');
end
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
text(aa,bb*0.9,strcat({'RMSECV='},{num2str(rms_test)}));
