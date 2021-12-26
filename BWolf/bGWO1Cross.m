function [Alpha_score,SAlpha_pos]=bGWO1Cross(nPop,MaxIt,Dim,Method,fobj)
%% BGWO1 Parameters

Alpha_score=inf;
Beta_score=inf;
Delta_score=inf;

Alpha_pos=zeros(1,Dim);
Delta_pos=zeros(1,Dim);
Beta_pos=zeros(1,Dim);

%% initialization
Positions=initialization(nPop,Dim,1,0,Method)>0.5;

it=0;
while it<MaxIt
    for i=1:size(Positions,1) %for each wolf
        % Calculate objective function for each search agent
          fitness=feval(fobj,Positions(i,:));
       
        % Update Alpha, Beta, and Delta
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
    
    % a decreases linearly fron 2 to 0
    a=2-it*((2)/MaxIt);
    
    for i=1:size(Positions,1) %for each wolf
        for j=1:size(Positions,2) %for each feature
            %% Alpha
            r1=rand();  % r1 is a random number in [0,1]
            r2=rand();  % r2 is a random number in [0,1]
            
            A1=2*a*r1-a;  % Equation (3)
            C1=2*r2;      % Equation (4)
            
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j));  % Equation (2)
            v1=sigmf(-A1*D_alpha,[10, 0.5]);              % Equation (16)
            % Equation (15)
            r=rand;
            if v1<r
                v1=0;
            else
                v1=1;
            end
            X1=(Alpha_pos(j)+v1)>=1;        % Equation (14)
            %% Beta
            
            r1=rand();  % r1 is a random number in [0,1]
            r2=rand();  % r2 is a random number in [0,1]
            
            A2=2*a*r1-a;
            C2=2*r2;
            
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j));
            v1=sigmf(-A2*D_beta,[10 0.5]);
            if v1<rand
                v1=0;
            else
                v1=1;
            end
            
            X2=(Beta_pos(j)+v1)>=1 ;
            %% Delta
            
            r1=rand();  % r1 is a random number in [0,1]
            r2=rand();  % r2 is a random number in [0,1]
            
            A3=2*a*r1-a;
            C3=2*r2;
            
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j));
            v1=sigmf(-A3*D_delta,[10 0.5]);%eq. 25
            if v1<rand
                v1=0;
            else
                v1=1;
            end
            X3=(Delta_pos(j)+v1)>=1;
          %%  
            Positions(i,j)=CrossOver(X1,X2,X3);      % Equation (23)
            
        end
    end
    it=it+1;
    
end



