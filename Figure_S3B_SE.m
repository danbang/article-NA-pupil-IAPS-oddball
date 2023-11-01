% Bang et al (2023) Noradrenaline tracks emotional modulation of attention
% in human amygdala
%
% Figure S3B: serotonin
%
% Plots critical conditions for 5-HT
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
%% VISUALISATION

% General specifications
c_colz(1,:)= [241 171 40]./255;
c_colz(2,:)= [100 149 237]./255;
lw= 2;
axisFS= 20;
labelFS= 24;
% Collate data
NT= tmpG.NT;
stimulus= tmpG.stimulus;
valence= tmpG.valence;
arousal= tmpG.arousal;
evocative= ((tmpG.valence~=0))*2-1;
v_var= [-1 1];
for i_var= 1:2;
    barz{i_var,1}= NT(stimulus==v_var(i_var) & evocative==-1);
    barz{i_var,2}= NT(stimulus==v_var(i_var) & evocative==+1);
end
% Create figure
fig=figure('color',[1 1 1],'pos',[10 10 300 300]);
fig.PaperPositionMode = 'auto';
hold on;
% Compute statistics
for i_var= 1:2;
    mu{i_var}(1)= mean(barz{i_var,1});
    se{i_var}(1)= std(barz{i_var,1}/sqrt(length(barz{i_var,1})));
    mu{i_var}(2)= mean(barz{i_var,2});
    se{i_var}(2)= std(barz{i_var,2}/sqrt(length(barz{i_var,2})));
end
% Reference lines
plot([0 3],[0 0],'k-','LineWidth',lw);
% Plot statistics
for i_var= 1:2;
    c_mu= mu{i_var};
    c_se= se{i_var};
    for t = 1:size(c_mu,2)-1;
        yplus1 = c_mu(t)+c_se(t);
        yplus2 = c_mu(t+1)+c_se(t+1);
        yminus1= c_mu(t)-c_se(t);
        yminus2 = c_mu(t+1)-c_se(t+1);
        fill([t t t+1 t+1],[yminus1 yplus1 yplus2 yminus2],[0 0 0],'Edgecolor','none','FaceAlpha',.15);
    end
    plot(1:2,c_mu,'-','Color',c_colz(i_var,:),'LineWidth',lw*2); 
end
% Tidy up
ylim([-.3 .5]);
xlim([.5 2.5]);
set(gca,'YTick',-6:.2:.9);
set(gca,'XTick',[1 2],'XTickLabel',{'No','Yes'});
set(gca,'FontSize',axisFS,'LineWidth',lw);
ylabel(['Estimated ',NT_for_plot,' [{\itz}]'],'FontSize',labelFS);
xlabel('Evocative','FontSize',labelFS);
axis square;
% Print
print('-djpeg','-r300',['Figures/Figure-S3B-',NT_for_plot]);