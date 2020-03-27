% Yksinkertainen malli tarttuvan taudin leviämiselle. Tämä ei perustu
% differentiaaliyhtälöihin vaan todennäköisyyspohjaisiin siirtymisiin
% kategoriasta toiseen. Pohjalan on SIR-malli, jossa jokainen henkilö 
% kuuluu yhteen seuraavista kategorioista: 
% S sairaudelle alttiit (Susceptile)
% I infektoituneet (Infected)
% R rentoutuneet (taudin sairastaneet ja immuuniksi muuttuneet) (Recovered)
% 
% Mallin taustalla on klassinen SIR-malli, katso esimerkiksi 
% https://www.maa.org/press/periodicals/loci/joma/the-sir-model-for-spread-of-disease-the-differential-equation-model
%
% Samuli Siltanen maaliskuu 2020

%% Valmisteluja


% Kuinka monta epidemiaa mallinnetaan
Nepidemics = 100;

% Graafisia parametreja
fsize = 30;
lwidth = 3;

% Ihmisten määrä mallissa
N = 10000;

% Kuinka monta päivää simulaatiota ajetaan
Nt = 100;

% Montako muuta ihmistä yksi henkilö tapaa päivässä keskimäärin
Nmeet = 20;

% Montako päivää kestää parantua taudista
Nrecov = 5;

% Sairaudelle alttiin henkilön todennäköisyys saada tartunta, 
% kun on kohdannut infektoituneen henkilön
Pinf = .5;

% Montako sairaalasänkyä on käytössä
Nbeds = round(N/3);
Nbeds = 2500;

% Perusta ikkuna kuvaa varten
figure(1)
clf

% Piirrä perustilanne kuvaan 
plot([1,Nt],[Nbeds,Nbeds],'k','linewidth',2)
t1 = text(.35*Nt,1.1*Nbeds,'Sairaalapaikkojen määrä');
set(t1,'fontsize',fsize)
axis([1 Nt 0 N])
xlabel('Aika (päiviä)','fontsize',fsize)
ylabel('Tartunnan saaneiden määrä','fontsize',fsize)
set(gca,'ytick',[1000:1000:N],'fontsize',fsize)
hold on

%% For-luuppi epidemioiden yli
for ppp = 1:Nepidemics
    
    % Alustetaan tilannematriisi, joka kuvaa epidemian kulun päivä päivältä. 
    % Jokaiselle päivälle on oma sarakkeensa. 
    % Ensimmäinen rivi kertoo infektoituneiden ihmisten määrän I
    % Toinen rivi kertoo rentoutuneiden ihmisten määrän R
    % Jokaisena päivänä S = N-(I+R).
    SIRmat = zeros(2,Nt);
    
    % N-ulotteinen vektori, jossa on ihmisten tilanteet listattuna
    % 1 = Susceptible
    % 2 = Infected
    % 3 = Recovered
    peoplevec = ones(1,N);
    
    % Ensimmäisenä päivänä on yksi sairastunut
    peoplevec(randi(N)) = 2;
    SIRmat(1,1) = 1;
    
    % For-luuppi päivien yli, alkaen päivästä 2
    for iii = 2:Nt
        
        % Uudet infektiot. 
        % Poimitaan satunnaisesti ihmiset, jotka ovat kohdanneet sairastuneen.        
        % Otetaan heistä esiin sairaudelle alttiit; tästä joukosta
        % sairastuu osa todennäköisyyden Pinf mukaisesti
        peoplevec = peoplevec(randperm(length(peoplevec))); % Satunnainen sekoitus
        N_met_sick = Nmeet*SIRmat(1,iii-1); % Näin moni kohtasi sairastuneen
        for jjj = 1:min(N_met_sick,N)
            if (peoplevec(jjj)==1)&(rand<Pinf)
                peoplevec(jjj) = 2;
            end
        end
        
        % Rentoituneiden luominen eli sairaudesta paraneminen. 
        if iii>Nrecov % Paraneminen alkaa Nrecov päivän jälkeen
            for jjj = 1:N
                if (peoplevec(jjj)==2)&(rand<(1/Nrecov))
                    peoplevec(jjj) = 3;
                end
            end
        end
        
        % Päivitä tilannematriisi
        SIRmat(1,iii) = length(find(peoplevec==2));
        SIRmat(2,iii) = length(find(peoplevec==3));
    end
    
    % Piirrä kuva
    figure(1)
    plot([1:Nt],SIRmat(1,:),'r','linewidth',lwidth)
    axis([1 Nt 0 N])
    t2 = text(.1*Nt,17/25*N,[num2str(Nmeet),' kohtaamista päivässä']);
    set(t2,'fontsize',fsize,'color',[1 0 0])
    drawnow
    
end


%% Lasketaan, mitä tapahtuu, kun vähennämme ihmisten välisiä kohtaamisia

% Muuten lasku on täysin sama kuin yllä; siksi jätän kommentit pois. 

% Montako muuta ihmistä yksi henkilö tapaa päivässä keskimäärin
Nmeet = 1;

for ppp = 1:Nepidemics
    
    SIRmat = zeros(2,Nt);
    peoplevec = ones(1,N);
    peoplevec(randi(N)) = 2;
    SIRmat(1,1) = 1;
    
    for iii = 2:Nt
        peoplevec = peoplevec(randperm(length(peoplevec)));
        N_met_sick = Nmeet*SIRmat(1,iii-1); 
        for jjj = 1:min(N_met_sick,N)
            if (peoplevec(jjj)==1)&(rand<Pinf)
                peoplevec(jjj) = 2;
            end
        end
        
        if iii>Nrecov 
            for jjj = 1:N
                if (peoplevec(jjj)==2)&(rand<(1/Nrecov))
                    peoplevec(jjj) = 3;
                end
            end
        end
        
        SIRmat(1,iii) = length(find(peoplevec==2));
        SIRmat(2,iii) = length(find(peoplevec==3));
    end
    
    % Piirrä kuva
    figure(1)
    plot([1:Nt],SIRmat(1,:),'b','linewidth',lwidth)
    axis([1 Nt 0 N])
    t3 = text(.5*Nt,4.5/25*N,[num2str(Nmeet),' kohtaaminen päivässä']);
    set(t3,'fontsize',fsize,'color',[0 0 1])
    title('Samun simppeli epidemiamalli','fontsize',fsize)
    drawnow
end


