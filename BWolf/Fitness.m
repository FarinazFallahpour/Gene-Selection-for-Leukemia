function y=Fitness(x)
%% Define Parameter
K=5;
beta=0.01;      
alpha=1-beta;
%  For each dataset, the instances are randomly divided into three sets namely training, validation and testing sets
global A TestVec TestClass  ;
r=randperm(size(A,1));

rTrain=r(1:floor(length(r)/3));
rValid=r(floor(length(r)/3)+1:floor(length(r)*2/3));
rTest=r(floor(length(r)*2/3)+1:end);

x=x<0.5;
x=cat(2,x,zeros(size(x,1),1));
x=logical(x);
C=length(x)-1;
R=sum(x);
if sum(x)==0
    y=inf;
    return;
end
% Train Data set
TrainVec=A(rTrain,x);
TrainClass=A(rTrain,end);

% Validation Data set
ValidVec=A(rValid,x);
ValidClass=A(rValid,end);

% Validation Data set
TestVec=A(rTest,x); 
TestClass=A(rTest,end);  

%  k-nearest neighbor classification
CP = classperf(ValidClass); %#ok
Class = knnclassify(ValidVec,TrainVec,TrainClass,K);
CP = classperf(ValidClass,Class);


ER=1-CP.CorrectRate;      % Correctly Classified Samples / Classified Samples



y=alpha*ER+beta*R/C;      % Equation 27



