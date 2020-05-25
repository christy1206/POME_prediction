# POME_prediction

Six different models derived from machine learning were developed in describing the response of POME degradation (%) with respects to all three main factors (O2 flowrate, TiO2 loadings and Initial concentration of POME) and interactions among them. 
A 5-fold cross validation classification strategy is adopted and the performance metrics to evaluate the models are RMSE and R2.

The 6 models are:
1) Gaussian process regression (GPR)
2) Linear regression (LR)
3) Decision tree (DT)
4) Support Vector Machine (SVM)
5) Regression Tree Ensemble (RTE)
6) Quadratic curve fitting

Software is written and tested using Matlab 2020a, toolbox required:

1) Statistics and Machine Learning Toolbox

The files include:

1) data.txt : The 58 data sets of experimental runs
2) 1_GPR.m : Script that utilizes GPR model 
3) 2_LR.m : Script that utilizes LR model
4) 3_DT.m : Script that utilizes DT model
5) 4_SVM.m : Script that utilizes SVM model
6) 5_RTE.m : Script that utilizes RTE model
7) 6_quadratic : Script that utilizes quadratic curve fitting model

Contour plots and the 3D surface response plots between O2 flow rate and TiO2 loading at 250ppm POME initial concentration for the baseline and GPR methods:

<img src="https://github.com/christy1206/POME_prediction/blob/picture/Capture.JPG" width="1000" height="400"/>


If you have suggestions or questions regarding this method, please reach out to stliong@fcu.edu.tw

Thank you for your interest and support.
