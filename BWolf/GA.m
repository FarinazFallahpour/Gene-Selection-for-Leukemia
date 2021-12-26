function [BEST,POSI]=GA(nPop,MaxIt,Dim,Method)
%% Problem Definition
CostFunction=@(x) Fitness(x);        % Cost Function

VarMin=0;         % Lower Bound of Variables
VarMax=1;         % Upper Bound of Variables

%% GA Parameters
pc=0.8;                      % percent of crossover
nCross=2*round(nPop*pc/2);   % number of cross over offspring
pm=1-pc;                     % percent of mutation
nMut=round(nPop*pm);         % number of mutation offsprig

%% initialization
tic
empty.Position=[];
empty.Cost=[];


POP=repmat(empty,nPop,1);
for i=1:nPop
    POP(i).Position=initialization(1,Dim,1,0,Method)>0.5;
    POP(i).Cost=CostFunction(POP(i).Position);   
end


%% main loop
BEST=zeros(MaxIt,1);

for iter=1:MaxIt
  % crossover
   Crosspop=repmat(empty,nCross,1);
   P=[POP.Cost];
   P=P./sum(P);
   P=cumsum(P);


for n=1:2:nCross
       
    % Select Parents Indices (Roulette Wheel Selection)
    i1=find(rand<=P,1,'first');
    i2=find(rand<=P,1,'first');
    
    p1=POP(i1).Position;
    p2=POP(i2).Position;
    
    % Apply Single Point Crossover
    R=rand(size(p1));
    o1=(p1.*R)+(p2.*(1-R));
    o2=(p2.*R)+(p1.*(1-R));
    Crosspop(n).Position=o1;
    Crosspop(n).Cost=CostFunction(o1);
    
    Crosspop(n+1).Position=o2;
    Crosspop(n+1).Cost=CostFunction(o2);
    
end

    % Mutation
   Mutpop=repmat(empty,nMut,1);
   for n=1:nMut
   
       i=randi([1 nPop]);
       p=POP(i).Position;
       mu=0.8;
       nMutu=ceil(mu*Dim);
       j=randsample(Dim,nMutu);
       
       d=0.8*unifrnd(0,1);
       p(j)=p(j)+d;
       p=min(VarMax,max(p,VarMin)); %#ok
           
       Mutpop(n).Cost=CostFunction(Mutpop(n).Position);
           
   end

 
   % merged
  [POP]=[POP;Crosspop;Mutpop];

  % select
  [~,index]=sort([POP.Cost]);
  POP=POP(index);
  POP=POP(1:nPop);

 BestSol=POP(1);   % global pop

 BEST=min(BestSol.Cost);
 POSI=sum(BestSol.Position);
 end

end
