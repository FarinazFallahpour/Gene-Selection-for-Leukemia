function [Alpha_score,SAlpha_pos]=bGWO2Sig(nPop,MaxIt,Dim,Method,fobj)
%% BGWO2 Parameters

Alpha_score=inf;
Beta_score=inf;
Delta_score=inf;

Alpha_pos=zeros(1,Dim);
Delta_pos=zeros(1,Dim);
Beta_pos=zeros(1,Dim);

%% initialization
Positions=initialization(nPop,Dim,1,0,Method)>0.5; % >0.5 for Binary


it=0;
while it<MaxIt 
    for i=1:size(Positions,1) %for each wolf
        fitness=feval(fobj,Positions(i,:));
        
        if fitness<Alpha_score
            Alpha_score=fitness;
            Alpha_pos=Positions(i,:);
            SAlpha_pos=sum(Alpha_pos);
        end
        
        if fitness>Alpha_score && fitness<Beta_score
            Beta_score=fitness;
            Beta_pos=Positions(i,:);
        end
        
        if fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score
            Delta_score=fitness;
            Delta_pos=Positions(i,:);
        end
    end
    
    
    a=2-it*((2)/MaxIt);
    
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)
            %% Alpha
            r1=rand();   % r1 is a random number in [0,1]
            r2=rand();   % r2 is a random number in [0,1]
            
            A1=2*a*r1-a; % Equation (3) / Search for prey (exploration)
            C1=2*r2;     % Equation (4)
            
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j));    % Equation (2)
            X1=Alpha_pos(j)-A1*D_alpha; % Equation (1)
            
            %% (Beta)
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a;
            C2=2*r2;
            
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j));
            X2=Beta_pos(j)-A2*D_beta;
         
            %%  (Delta)
            r1=rand();
            r2=rand();
            A3=2*a*r1-a;
            C3=2*r2;
            
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j));
            X3=Delta_pos(j)-A3*D_delta;
            %%
            Positions(i,j)=(sigmf(((X1+X2+X3)/3),[10 0.5])>=rand); % Equation (24)
            
        end
        
    end
    it=it+1;
end



