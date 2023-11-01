% Bang et al (2023) Noradrenaline tracks emotional modulation of attention
% in human amygdala
%
% Figure S3A: serotonin
%
% Plots output of LME analysis of 5-HT
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
dirDataB= [dirBase,fs,'Data',fs,'Patients',fs,'Behaviour']; % behaviour
dirDataC= [dirBase,fs,'Data',fs,'Patients',fs,'Calibration']; % in-vitro calibration
dirDataP= [dirBase,fs,'Data',fs,'Patients',fs,'Pupillometry']; % pupillometry
dirDataV= [dirBase,fs,'Data',fs,'Patients',fs,'Voltammetry']; % voltammetry

% Population
group= 'MM'; % macro-micro patients

% Neuromodulator
NT= 'SE';
NT_for_plot= '5-HT';

% Subjects
n_sbj= 3;

%% -----------------------------------------------------------------------
%% COLLATE DATA FOR GROUP-LEVEL ANALYSIS

% Initialise group variables
tmpG.NT= [];
tmpG.valence= [];
tmpG.arousal= [];
tmpG.stimulus= [];
tmpG.dataset= [];

% Loop through subjects
for i_sbj= 1:n_sbj;

    % Load data
    c_sbj= sprintf( '%03d', i_sbj);
    load([dirDataB,fs,group,'_',c_sbj,'.mat']);
    load([dirDataV,fs,group,'_',c_sbj,'_',NT,'.mat']);

    % Calculate NT AUC (one column = .1 seconds; column 31 = stimulus onset)
    for i_trial= 1:size(timeSeries,1)
        AUC(i_trial)= nanmean(timeSeries(i_trial,26:35))-nanmean(timeSeries(i_trial,21:25));
    end 

    % Collate
    idx= ~isnan(AUC);
    tmpG.NT= [tmpG.NT; zscore(AUC(idx))'];
    tmpG.valence= [tmpG.valence; data.valence(idx)'];
    tmpG.arousal= [tmpG.arousal; data.arousal(idx)'];
    tmpG.stimulus= [tmpG.stimulus; (data.stimulus(idx)'*2-1)];
    tmpG.dataset= [tmpG.dataset; ones(1,sum((idx)))'.*i_sbj];
    
end

%% -----------------------------------------------------------------------
%% RUN GROUP-LEVEL ANALYSIS

% LME
% Variables
NT= tmpG.NT;
stimulus= tmpG.stimulus;
valence= tmpG.valence;
arousal= tmpG.arousal;
evocative= ((tmpG.valence~=0))*2-1;
dataset= tmpG.dataset;
% evocative(evocative==-1)= 0; % simple-effect of stimulus for evocative
% evocative(evocative==+1)= 0; % simple-effect of stimulus for neutral
% stimulus(stimulus==-1)= 0; % simple-effect of evocative for standard
% stimulus(stimulus==+1)= 0; % simple-effect of evocative for oddball
% Format
datanames= {'NT','stimulus','valence','arousal','evocative','dataset'};
datatab= table(NT,stimulus,valence,arousal,evocative,categorical(dataset),'VariableNames',datanames);
% Formula
formulaz= 'NT ~ 1 + (evocative+arousal*valence)*stimulus + (1 | dataset)';
% Run
lmehat= fitglme(datatab,formulaz,'distribution','normal','Link','identity','FitMethod','REMPL');

%% -----------------------------------------------------------------------
%% VISUALISE GROUP-LEVEL RESULTS

% General specifications
colz= [0 255 255;
       255 0 255]./255;
linez= {'-',':'};
alphaz= .6;
lw= 2;
axisFS= 20;
labelFS= 24;
titleFS= 16;
ms= 14;
plot_order= {'stimulus', ...                %1
             'valence', ...                 %2
             'arousal', ...                 %3
             'evocative', ...               %4
             'stimulus:valence', ...        %5
             'stimulus:arousal', ...        %6
             'stimulus:evocative', ...      %7
             'valence:arousal', ...         %8
             'stimulus:valence:arousal'};   %9
% Create figure
fig=figure('color',[1 1 1],'pos',[10 10 335 335]);
fig.PaperPositionMode = 'auto';
hold on;
% Parse LME output
for i_var= 1:length(plot_order);
    c_idx= find(strcmp(lmehat.CoefficientNames,plot_order{i_var}));
    beta_est(i_var)= lmehat.Coefficients.Estimate(c_idx);
    beta_sem(i_var)= lmehat.Coefficients.SE(c_idx);     
end
% Plot LME output
for i_var= 1:length(plot_order);
    c_beta_est= beta_est(i_var);
    c_beta_sem= beta_sem(i_var);
    barh(i_var,c_beta_est,'LineWidth',lw,'Facecolor',[255 100 100]./255,'Edgecolor',[0 0 0],'FaceAlpha',.5);
    plot([c_beta_est-c_beta_sem c_beta_est+c_beta_sem],[i_var i_var],'k-','LineWidth',lw);
end    
% Reference lines
plot([0 0],[0 length(plot_order)+1],'k-','LineWidth',lw);
% Tidy up
set(gca,'FontSize',axisFS,'LineWidth',lw);
set(gca,'ydir','reverse');
% Y-axis
set(gca,'YTick',1:9,'YTickLabel',{'{\itT} (type)','{\itV} (valence)','{\itA} (arousal)','{\itE} (evocative)','{\itT}x{\itV} ','{\itT}x{\itA} ','{\itT}x{\itE} ','{\itV}x{\itA} ',' {\itT}x{\itV}x{\itA} '});
xlabel('Coefficient [a.u.]','FontSize',labelFS);
ylim([0 length(plot_order)+1]);
% X-axis
set(gca,'XTick',-.1:.1:.3);
xlabel('Coefficient [a.u.]','FontSize',labelFS);
xlim([-.17 .17]);
% Square
axis square;
% Print
print('-djpeg','-r300',['Figures/Figure-S3A-',NT_for_plot]);