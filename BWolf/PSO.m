function [BEST,POSI]=PSO(nPop,MaxIt,Dim,Method)

%% Problem Definition
CostFunction=@(x) Fitness(x);        % Cost Function
VarSize=[1 Dim];   % Size of Decision Variables Matrix

VarMin=0;         % Lower Bound of Variables
VarMax=1;         % Upper Bound of Variables

%% PSO Parameters
w=0.1;          % Inertia Weight
c1=2;           % Personal Learning Coefficient
c2=2;           % Global Learning Coefficient

% Constriction Coefficients
% phi1=2.05;
% phi2=2.05;
% phi=phi1+phi2;
% chi=2/(phi-2+sqrt(phi^2-4*phi));
% w=chi;          % Inertia Weight
% wdamp=1;        % Inertia Weight Damping Ratio
% c1=chi*phi1;    % Personal Learning Coefficient
% c2=chi*phi2;    % Global Learning Coefficient

% Velocity Limits
VelMax=0.1*(VarMax-VarMin);
VelMin=-VelMax;

%% Initialization

empty.Position=[];
empty.Cost=[];

empty.Velocity=[];

empty.Best.Position=[];
empty.Best.Cost=[];

particle=repmat(empty,nPop,1);

BestSol.Cost=inf;

for i=1:nPop
    
    % Initialize Position SearchAgents_no,dim,ub,lb
    particle(i).Position=initialization(1,Dim,1,0,Method)>0.5;
    
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    
    % Evaluation
    particle(i).Cost=CostFunction(particle(i).Position);
    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    
    % Update Global Best
    if particle(i).Best.Cost<BestSol.Cost
        BestSol=particle(i).Best;
    end
    
end

BEST=zeros(MaxIt,1);

%% PSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(BestSol.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
        
        % Evaluation
        particle(i).Cost = CostFunction(particle(i).Position);
        
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            
            
            % Update Global Best
            if particle(i).Best.Cost<BestSol.Cost
                BestSol=particle(i).Best;
            end
            
        end
        
    end
    BEST=min(BestSol.Cost);
 POSI=sum(BestSol.Position);

end

end
