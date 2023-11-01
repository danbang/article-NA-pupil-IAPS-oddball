% Bang et al (2023) Noradrenaline tracks emotional modulation of attention
% in human amygdala
%
% Figure 2B: patients
%
% Plots oddball PDR
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

% Subjects
n_sbj= 3;

%% -----------------------------------------------------------------------
%% COLLATE DATA FOR GROUP-LEVEL ANALYSIS

% Initialise group variables
tmpG.pupil= [];
tmpG.valence= [];
tmpG.arousal= [];
tmpG.stimulus= [];
tmpG.illuminance= [];
tmpG.dataset= [];
tmpG.include= [];
tmpG.trialInBlock= [];
tmpG.pstimulus= [];
tmpG.pilluminance= [];
tmpG.pinclude= [];

% Loop through subjects
for i_sbj= 1:n_sbj;

    % Load data
    c_sbj= sprintf( '%03d', i_sbj);
    load([dirDataB,fs,group,'_',c_sbj,'.mat']);
    load([dirDataP,fs,group,'_',c_sbj,'.mat']);

    %% Pre-processsing pupil

    % Reassing
    clear tmp;
    tmp.pupil.left= pupil.recon.left;
    tmp.pupil.right= pupil.recon.right;
    tmp.isrec.left= pupil.isrec.left;
    tmp.isrec.right= pupil.isrec.right;
    clear pupil;
    
    % Average across eyes
    for i_trial= 1:size(tmp.pupil.left,1);
       pupil.timeSeries(i_trial,:)= nanmean([tmp.pupil.left(i_trial,:); tmp.pupil.right(i_trial,:)]); 
    end
    for i_trial= 1:size(tmp.isrec.left,1);
        pupil.isrec(i_trial,:)= nanmean([tmp.isrec.left(i_trial,:); tmp.isrec.right(i_trial,:)]); 
    end
    
    % Trial exclussions
    cut_frac= .5;
    pupil.include= (sum((isnan(pupil.timeSeries)+~isnan(pupil.timeSeries).*pupil.isrec),2)/size(pupil.isrec,2))<cut_frac;

    % Downsample (DS)
    oL= 601;
    nL= 61;
    xq= linspace(1,oL,nL);
    for i_trial= 1:size(pupil.timeSeries,1);
       pupil.timeSeries_DS(i_trial,:)= interp1(1:oL,pupil.timeSeries(i_trial,:),xq);
    end
    
    % Z-score (Z)
    for i_trial= 1:size(pupil.timeSeries_DS,1);
       pupil.timeSeries_DS_Z(i_trial,:)= ( pupil.timeSeries_DS(i_trial,:) - nanmean(pupil.timeSeries_DS(i_trial,:)) ) / nanstd(pupil.timeSeries_DS(i_trial,:)) ;
    end
    
    % Smooth (S)
    winS= 5;
    pupil.timeSeries_DS_ZS= pupil.timeSeries_DS_Z;
    pupil.timeSeries_DS_ZS(:,1:winS-1)= zeros(size(pupil.timeSeries_DS_ZS,1),winS-1);
    for t= winS:size(pupil.timeSeries_DS_ZS,2)
        pupil.timeSeries_DS_ZS(:,t)= mean(pupil.timeSeries_DS_Z(:,(t+1-winS):t),2);
    end
    
    % Detrend (T)
    for t= 1:size(pupil.timeSeries_DS_ZS,1)
        pupil.timeSeries_DS_ZST(t,:)= detrend_nonan(pupil.timeSeries_DS_ZS(t,:));
    end
    
    %% Collate
    
    % History
    data.trialInBlock= repmat(1:100,1,6);
    data.pstimulus= [0 data.stimulus(1:end-1)];
    data.pstimulus_descriptive_illuminance= [0 data.stimulus_descriptive_illuminance(1:end-1)];
    pupil.pinclude= [0; pupil.include(1:end-1)];

    % Collate group
    tmpG.pupil= [tmpG.pupil; pupil.timeSeries_DS_ZST];
    tmpG.valence= [tmpG.valence; data.valence'];
    tmpG.arousal= [tmpG.arousal; data.arousal'];
    tmpG.stimulus= [tmpG.stimulus; (data.stimulus'*2-1)];
    tmpG.illuminance= [tmpG.illuminance; ((data.stimulus_descriptive_illuminance-min(data.stimulus_descriptive_illuminance))./(max(data.stimulus_descriptive_illuminance)-min(data.stimulus_descriptive_illuminance)))'];
    tmpG.dataset= [tmpG.dataset; ones(1,600)'.*i_sbj];
    tmpG.include= [tmpG.include; pupil.include];
    tmpG.trialInBlock= [tmpG.trialInBlock; data.trialInBlock'];
    tmpG.pstimulus= [tmpG.pstimulus; (data.pstimulus'*2-1)];
    tmpG.pilluminance= [tmpG.pilluminance; ((data.pstimulus_descriptive_illuminance-min(data.pstimulus_descriptive_illuminance))./(max(data.pstimulus_descriptive_illuminance)-min(data.pstimulus_descriptive_illuminance)))'];
    tmpG.pinclude= [tmpG.pinclude; pupil.pinclude];
    
end

%% -----------------------------------------------------------------------
%% RUN GROUP-LEVEL ANALYSIS AND VISUALISE RESULTS

% General specifications
linez= {'-',':'};
alphaz= .6;
lw= 2;
axisFS= 20;
labelFS= 24;
titleFS= 16;
ms= 8;
vis_beta_col= 'k';
vis_beta_style= '-';
vis_beta_lw= 4;   

%% ANALYSIS: ODDBALL VERSUS STANDARD
% Prepare variables for LME
idx= find(tmpG.include==1);
pupil= tmpG.pupil(idx,:);
valence= tmpG.valence(idx);
arousal= tmpG.arousal(idx);
stimulus= tmpG.stimulus(idx);
evocative= (valence~=0)*2-1;
dataset= tmpG.dataset(idx);
clear statz;
% Apply LME at each time point
for i_time= 1:size(pupil,2);
    datanames= {'pupil','valence','arousal','stimulus','evocative','dataset'};
    datatab= table(pupil(:,i_time),valence,arousal,stimulus,evocative,categorical(dataset),'VariableNames',datanames);
    formulaz= 'pupil ~ 1 + stimulus + (1|dataset)';
    lmehat= fitglme(datatab,formulaz,'distribution','normal','Link','identity','FitMethod','REMPL');
    statz.lme.beta(:,i_time)= lmehat.Coefficients.Estimate;
    statz.lme.pval(:,i_time)= lmehat.Coefficients.pValue;
    statz.lme.name(:,1)=      lmehat.Coefficients.Name;
end
% Create Figure
fig=figure('color',[1 1 1],'pos',[500 500 300 300]);
fig.PaperPositionMode = 'auto';
hold on;
% Load data
c_pupil_odd= nanmean(pupil(stimulus==1,:));
c_pupil_std= nanmean(pupil(stimulus==-1,:));
c_pupil_dff= c_pupil_odd-c_pupil_std;
% Add visual references
plot([1 61],[0 0],'k-','LineWidth',lw);
% Add stimulus
fill([31 31 41 41], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
% Plot data
plot(c_pupil_dff,vis_beta_style,'Color',vis_beta_col,'LineWidth',vis_beta_lw);
% Add significance
beta_n= 1;
beta_o= [2];
step_start= .6;
step_incre= .4;
for i_beta= 1:beta_n
    for i_time= 1:size(pupil,2);
        if statz.lme.pval(beta_o(i_beta),i_time)<.05;
            if sign(statz.lme.beta(beta_o(i_beta),i_time))==+1;
                plot(i_time,-step_start+-step_incre*i_beta,'k^','MarkerFaceColor','k','MarkerSize',ms);
            elseif sign(statz.lme.beta(beta_o(i_beta),i_time))==-1;
                plot(i_time,-step_start+-step_incre*i_beta,'kv','MarkerFaceColor','k','MarkerSize',ms);
            end
        end
    end
end
% Add timestamps to x-axis
set(gca,'XTick',[11 21 31 36 41 46 51],'XTickLabel',{'-2','-1','0','.5','1','1.5','2'});
xlim([31 51]);
% Tidy up
set(gca,'FontSize',axisFS,'LineWidth',lw);
% Adjust y-axis
set(gca,'YTick',-3:1:3);
ylim([-2 2]);
% Add axis labels
xlabel('Time [seconds]','FontSize',labelFS);
ylabel({'Pupil dilation [{\itz}]:','oddball-standard'},'FontSize',labelFS);
axis square
% Print
print('-djpeg','-r300',['Figures/Figure-2B-',group]);