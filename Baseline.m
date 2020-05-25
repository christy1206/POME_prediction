%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This script is to perform the linear regression fitting on 58
%  experimental data using 5-fold cross validation strategy
%
%  Reference:
%  xxxxx
%
%  Matlab version was written by Sze Teng Liong and was tested on Matlab 2019b
%  If you have any problem, please feel free to contact Sze Teng Liong (stliong@fcu.edu.tw)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a=dlmread('..\data_20200411.txt');
a = a(:,2:5); % remove numbering
degradation = a(:,4); % degradation
DATA = a(:,1:3); % TiO2 loading, O$_2$ flowrate and POME initial concentration

% 5-fold cross validation & quadratic curve fitting
cvp = cvpartition(size(degradation, 1), 'KFold', 5); 
validationPredictions = degradation;
for fold = 1:5
    trainingPredictors = DATA(cvp.training(fold), :);
    trainingResponse = degradation(cvp.training(fold), :);
    linearModel = LinearModel.fit(trainingPredictors,trainingResponse,'quadratic');
    linearModelPredictFcn = @(x) predict(linearModel, x);
    validationPredictFcn = @(x) linearModelPredictFcn(x);
    validationPredictors = DATA(cvp.test(fold), :);
    foldPredictions = validationPredictFcn(validationPredictors);
    validationPredictions(cvp.test(fold), :) = foldPredictions;
end

% compute RMSE and R2
y = degradation;
y_pred = validationPredictions;
yresid = degradation - y_pred;
SSresid = sum(yresid.^2);
SStotal = (length(y )-1) * var(y );
R2 = 1 - SSresid/SStotal; 
RMSE = sqrt(mean((yresid).^2));