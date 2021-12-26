clear all
clc
schema=[5 10 20 50];
dsNumber = size(schema,2);
% Ds=csvread('leukemia.csv',1,1);
Ds=load('luekemia.mat');
Ds=Ds.leukemia;
load('lb.mat');

lb(lb == -1)=2;
load('miq.mat')
for i = 1: dsNumber
   subDs = [];
    for j=1:schema(i)
        subDs = [subDs  Ds(:,miq(j))];
    end
  
    %concat labels
    subDs = [subDs  lb];
    name = sprintf('dataset%d.mat',i);
    save(name,'subDs');
end

load('mid.mat')
for i = 1: dsNumber
   subDs = [];
    for j=1:schema(i)
        subDs = [subDs  Ds(:,mid(j))];
    end
  
    %concat labels
    subDs = [subDs  lb];
    name = sprintf('dataset%d.mat',(i+dsNumber));
    save(name,'subDs');
end
