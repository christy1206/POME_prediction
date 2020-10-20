%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This script is to perform the GPR model on 58 experimental data using 5-fold cross validation strategy
%
%  Reference:
%  Ng, K. H., Gan, Y. S., Cheng, C. K., Liu, K. H., & Liong, S. T. (2020). Integration of machine learning-based prediction for enhanced Model’s generalization: Application in photocatalytic polishing of palm oil mill effluent (POME). Environmental Pollution, 267, 115500.
%
%  Matlab version was written by Sze Teng Liong and was tested on Matlab 2020a
%  If you have any problem, please feel free to contact Sze Teng Liong (stliong@fcu.edu.tw)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
a=dlmread('..\data.txt');
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
                
% Gaussian Process Regression
model = fitrgp(... 
    array2table(DATA), ...
    degradation, ...
    'BasisFunction', 'constant', ...
    'KernelFunction', 'exponential', ...
    'Standardize', true);
partitionedModel = crossval(model, 'KFold', 5); % 5-fold cross validation
y_pred = kfoldPredict(partitionedModel);    
    
% compute RMSE and R2
y = degradation;
yresid = degradation - y_pred;
SSresid = sum(yresid.^2);
SStotal = (length(y )-1) * var(y );
R2 = 1 - SSresid/SStotal; 
RMSE = sqrt(mean((yresid).^2));
