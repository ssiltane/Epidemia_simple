% Simple epidemic model with no differential equations
%
% Samuli Siltanen March 2020

%% Preliminaries


% Number of epidemics
Nepidemics = 100;

% Graphical parameters
fsize = 30;
lwidth = 3;

% Number of people in the village
N = 10000;

% Number of days in the simulation
Nt = 100;

% Number of people one person meets in a day on average
Nmeet = 20;

% Number of days needed for recovery
Nrecov = 5;

% Probability of infection
Pinf = .5;

% How many Intensive Care Unit beds are there
Nbeds = round(N/3);
Nbeds = 2500;

% Create plot window
figure(1)
clf
plot([1,Nt],[Nbeds,Nbeds],'k','linewidth',2)
%t1 = text(Nt/2,Nbeds+1,'Number of ICU beds');
t1 = text(.35*Nt,1.1*Nbeds,'Sairaalapaikkojen määrä');
set(t1,'fontsize',fsize)
axis([1 Nt 0 N])
%xlabel('Time (days)','fontsize',fsize)
xlabel('Aika (päiviä)','fontsize',fsize)
%ylabel('Number of infected people','fontsize',fsize)
ylabel('Tartunnan saaneiden määrä','fontsize',fsize)
set(gca,'ytick',[1000:1000:N],'fontsize',fsize)
hold on

%% Loop over epidemics
for ppp = 1:Nepidemics
    
    % Initialize matrix for recording status of people. The first row tells the
    % number of Infected people and the second row the number of Recovered.
    % At all times it holds that S = N-(I+R).
    SIRmat = zeros(2,Nt);
    
    % Status vector of people. Here
    % 1 = Susceptible
    % 2 = Infected
    % 3 = Recovered
    peoplevec = ones(1,N);
    
    % On the first day there is one infected person
    peoplevec(randi(N)) = 2;
    SIRmat(1,1) = 1;
    
    % Loop over days, starting from Day 2
    for iii = 2:Nt
        
        % New infections. Pick out people randomly from the population and
        % infect half of the susceptibles who met an infected person.
        peoplevec = peoplevec(randperm(length(peoplevec))); % Random shuffle
        N_met_sick = Nmeet*SIRmat(1,iii-1); % This many people met a sick person
        for jjj = 1:min(N_met_sick,N)
            if (peoplevec(jjj)==1)&(rand<Pinf)
                peoplevec(jjj) = 2;
            end
        end
        
        % Recoveries: infected people move to "recovered" category
        if iii>Nrecov % Recoveries start after Nrecov days
            for jjj = 1:N
                if (peoplevec(jjj)==2)&(rand<(1/Nrecov))
                    peoplevec(jjj) = 3;
                end
            end
        end
        
        % Update situation matrix
        SIRmat(1,iii) = length(find(peoplevec==2));
        SIRmat(2,iii) = length(find(peoplevec==3));
    end
    
    % Plot the result
    figure(1)
    plot([1:Nt],SIRmat(1,:),'r','linewidth',lwidth)
    %plot([1:Nt],SIRmat(1,:),'r.')
    % plot([1:Nt],SIRmat(2,:),'b')
    % plot([1:Nt],SIRmat(2,:),'b.')
    axis([1 Nt 0 N])
    t2 = text(.1*Nt,17/25*N,[num2str(Nmeet),' kohtaamista päivässä']);
    set(t2,'fontsize',fsize,'color',[1 0 0])
    drawnow
    
end


%% Let's compare the above to the case of social distancing
% Number of people one person meets in a day on average
Nmeet = 1;

% Loop over epidemics
for ppp = 1:Nepidemics
    
    % Initialize matrix for recording status of people. The first row tells the
    % number of Infected people and the second row the number of Recovered.
    % At all times it holds that S = N-(I+R).
    SIRmat = zeros(2,Nt);
    
    % Status vector of people. Here
    % 1 = Susceptible
    % 2 = Infected
    % 3 = Recovered
    peoplevec = ones(1,N);
    
    % On the first day there is one infected person
    peoplevec(randi(N)) = 2;
    SIRmat(1,1) = 1;
    
    % Loop over days, starting from Day 2
    for iii = 2:Nt
        
        % New infections. Pick out people randomly from the population and
        % infect half of the susceptibles who met an infected person.
        peoplevec = peoplevec(randperm(length(peoplevec))); % Random shuffle
        N_met_sick = Nmeet*SIRmat(1,iii-1); % This many people met a sick person
        for jjj = 1:min(N_met_sick,N)
            if (peoplevec(jjj)==1)&(rand<Pinf)
                peoplevec(jjj) = 2;
            end
        end
        
        % Recoveries: infected people move to "recovered" category
        if iii>Nrecov % Recoveries start after Nrecov days
            for jjj = 1:N
                if (peoplevec(jjj)==2)&(rand<(1/Nrecov))
                    peoplevec(jjj) = 3;
                end
            end
        end
        
        % Update situation matrix
        SIRmat(1,iii) = length(find(peoplevec==2));
        SIRmat(2,iii) = length(find(peoplevec==3));
    end
    
    % Plot the result
    figure(1)
    plot([1:Nt],SIRmat(1,:),'b','linewidth',lwidth)
    axis([1 Nt 0 N])
    t3 = text(.5*Nt,4.5/25*N,[num2str(Nmeet),' kohtaaminen päivässä']);
    set(t3,'fontsize',fsize,'color',[0 0 1])
    title('Samun simppeli epidemiamalli','fontsize',fsize)
    drawnow
end


