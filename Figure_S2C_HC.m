% Bang et al (2023) Noradrenaline tracks emotional modulation of attention
% in human amygdala
%
% Figure S2C: healthy controls
%
% Analyses RTs and plots RTs for each condition
%
% Dan Bang danbang@cfin.au.dk 2023

%% -----------------------------------------------------------------------
%% PREPARATION

% Fresh memory
clear;

% Custom functions
addpath('Functions');

% Paths [edit 'getBase' according to local setup]
fs= filesep;
dirBase= getBase;
dirDataB= [dirBase,fs,'Data',fs,'Controls',fs,'Behaviour']; % behaviour
dirDataP= [dirBase,fs,'Data',fs,'Controls',fs,'Pupillometry']; % pupillometry

% Population
group= 'HC'; % macro-micro patients

% Subjects
n_sbj= 17;

%% -----------------------------------------------------------------------
%% COLLATE DATA FOR GROUP-LEVEL ANALYSIS

% Initialise group variables
tmpG.rt= [];
tmpG.rtRaw= [];
tmpG.valence= [];
tmpG.arousal= [];
tmpG.stimulus= [];
tmpG.dataset= [];

% Loop through subjects
for i_sbj= 1:n_sbj;

    % Load data
    c_sbj= sprintf( '%03d', i_sbj);
    load([dirDataB,fs,group,'_',c_sbj,'.mat']);
    
    % Reaction times
    data.reactiontime(data.buttonpress~=1)= NaN;
    data.reactiontimeNormLog= NaN(1,600);
    idx= find(data.buttonpress==1);
    c_rts= zscore(log(data.reactiontime(idx)));
    for i_trial= 1:length(idx);
       data.reactiontimeNormLog(idx(i_trial))= c_rts(i_trial); 
    end
    
    % Collate group
    tmpG.rt= [tmpG.rt; data.reactiontimeNormLog'];
    tmpG.rtRaw= [tmpG.rtRaw; data.reactiontime'];
    tmpG.valence= [tmpG.valence; data.valence'];
    tmpG.arousal= [tmpG.arousal; data.arousal'];
    tmpG.stimulus= [tmpG.stimulus; (data.stimulus'*2-1)];
    tmpG.dataset= [tmpG.dataset; ones(1,600)'.*i_sbj];
    
end

%% -----------------------------------------------------------------------
%% RUN GROUP-LEVEL ANALYSIS

% LME
% Variables
idx= find(~isnan(tmpG.rt));
rt= tmpG.rt(idx);
stimulus= tmpG.stimulus(idx);
valence= tmpG.valence(idx);
arousal= tmpG.arousal(idx);
evocative= ((tmpG.valence(idx)==0))*2-1;
dataset= tmpG.dataset(idx);
% Format
datanames= {'rt','valence','arousal','stimulus','evocative','dataset'};
datatab= table(rt,valence,arousal,stimulus,evocative,categorical(dataset),'VariableNames',datanames);
% Formula
formulaz= 'rt ~ 1 + (evocative+arousal*valence) + (1 | dataset)';
% Run
rt_lmehat= fitglme(datatab,formulaz,'distribution','normal','Link','identity','FitMethod','REMPL');

%% -----------------------------------------------------------------------
%% VISUALISE RESULTS

% General specifications
lw= 2;
axisFS= 20;
labelFS= 24;
colz=       [254 204 203; ...
             255 102 103; ...
             205 255 204; ...
             102 255 102; ...
             102 102 255]./255;

% Variables
idx= find(~isnan(tmpG.rtRaw));
rt= tmpG.rtRaw(idx);
valence= tmpG.valence(idx);
arousal= tmpG.arousal(idx);
% Collate data
barz{1}= rt(valence==-1 & arousal==-1);
barz{2}= rt(valence==-1 & arousal==+1);
barz{3}= rt(valence==+1 & arousal==-1);
barz{4}= rt(valence==+1 & arousal==+1);
barz{5}= rt(valence==00 & arousal==00);
% Create figure
fig=figure('color',[1 1 1],'pos',[500 500 300 300]);
fig.PaperPositionMode = 'auto';
% Plot conditions
hold on;
for i_bar= 1:5
    mu= mean(barz{i_bar});
    se= std(barz{i_bar})./sqrt(length(barz{i_bar}));
    plot([i_bar i_bar],[mu-se mu+se],'k-','LineWidth',2);
    plot(i_bar,mu,'ko','MarkerFaceColor',colz(i_bar,:),'MarkerSize',10,'LineWidth',2);
end
% Tidy up
set(gca,'FontSize',axisFS,'LineWidth',lw);
% Add timestamps to x-axis
set(gca,'XTick',[]);
xlim([0 6]);
% Adjust y-axis
set(gca,'YTick',[.44 .46 .48]);
ylim([.42 .5]);
% Add axis labels
xlabel('Block','FontSize',labelFS);
ylabel('Reaction time [s]','FontSize',labelFS);
axis square
% Print
print('-djpeg','-r300',['Figures/Figure-S2C-',group]);