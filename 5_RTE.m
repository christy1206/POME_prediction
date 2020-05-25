%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This script is to perform the RTE model on 58 experimental data using 5-fold cross validation strategy
%
%  Reference:
%  xxxxx
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
                
% Ensemble boosting
template = templateTree(...
    'MinLeafSize', 8);
model = fitrensemble(...
    DATA, ...
    degradation, ...
    'Method', 'LSBoost', ...
    'NumLearningCycles', 30, ...
    'Learners', template, ...
    'LearnRate', 0.1);
partitionedModel = crossval(model, 'KFold', 5); % 5-fold cross validation
y_pred = kfoldPredict(partitionedModel);    
    
% compute RMSE and R2
y = degradation;
yresid = degradation - y_pred;
SSresid = sum(yresid.^2);
SStotal = (length(y )-1) * var(y );
R2 = 1 - SSresid/SStotal; 
RMSE = sqrt(mean((yresid).^2));
