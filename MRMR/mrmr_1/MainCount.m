load('Ds-continous.mat')
a1=mrmr_miq_d(Ds(:,1:end-1), Ds(:,end), 100);
a2=mrmr_mid_d(Ds(:,1:end-1), Ds(:,end), 100);
a1'
a2'