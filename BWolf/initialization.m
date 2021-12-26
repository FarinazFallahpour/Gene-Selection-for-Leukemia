function Positions=initialization(SearchAgents_no,dim,ub,lb,Method)

Boundary_no= size(ub,2); % numnber of boundaries

if Boundary_no==1
   
    switch Method
        case 1   % Small(Random) initialization
            Positions=randsmall(SearchAgents_no,dim).*(ub-lb)+lb;
        case 2   % Random initialization
            Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;
        case 3   % Large(Random) initialization
            Positions=randnr(SearchAgents_no,dim).*(ub-lb)+lb;
            
        otherwise
            disp('other value Method');
    end
    
end
end