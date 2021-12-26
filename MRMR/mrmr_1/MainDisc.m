load('Ds-Discrete.mat')
a1=mrmr_miq_d(Ds(:,1:end-1), Ds(:,end), 20);
a2=mrmr_mid_d(Ds(:,1:end-1), Ds(:,end), 20);
a1'
a2'