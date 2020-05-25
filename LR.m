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
 
a=dlmread('D:\Gdrive\lst\chemi\data_20200411.txt');
 a = a(:,2:5); % remove numbering
degradation = a(:,4); % degradation
DATA = a(:,1:3); % TiO2 loading, O$_2$ flowrate and POME initial concentration

% generating 36 features
x = a(:,1);
y = a(:,2);
z = a(:,3);
A = [];
A = [A,x];
A = [A,y];
A = [A,z];
A = [A, x.*y];
A = [A, x.*z];
A = [A, y.*z];
A = [A, x.*x];
A = [A, y.*y];
A = [A, z.*z];

for i = 1: 9
    A = [A, log(A(:,i)+1)];
end
for i = 1: 9
    A = [A, A(:,i).^2];
end
for i = 1: 9
    A = [A, A(:,i).^3];
end   
    
DATA = A(:,1:36);

% 5-fold cross validation & Linear Regression
cvp = cvpartition(size(degradation, 1), 'KFold', 5);
validationPredictions = degradation;
for fold = 1:5
    trainingPredictors = DATA(cvp.training(fold), :);
    trainingResponse = degradation(cvp.training(fold), :);
    linearModel = fitlm(...
        array2table([trainingPredictors,trainingResponse]), ...
        'linear', ...
        'RobustOpts', 'off');
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