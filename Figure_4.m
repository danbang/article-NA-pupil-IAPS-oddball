% Bang et al (2023) Noradrenaline tracks emotional modulation of attention
% in human amygdala
%
% Figure 4
%
% Plots (a) the average pupil-NA timeseries and correlation statistics
% and (b) the HMM-based estimate of pupil-NA coupling for (1) all trials 
% irrespective of stimulus type, (2) oddball stimuli in low-arousal 
% blocks and (3) oddball stimuli in high-arousal. The average pupil-NA
% timeseries have been pre-processed as described in the paper
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
dirDataH= [dirBase,fs,'Data',fs,'Patients',fs,'HMM']; % HMM

% Population
group= 'MM'; % macro-micro patients

% Load data
load([dirDataH,fs,'hmm.mat']);

%% -----------------------------------------------------------------------
%% VISUALISATION: GENERAL

% General specifications
alphaz= .6;
lw= 4;
datalw= 2;
axisFS= 20;
labelFS= 24;
titleFS= 12;
ms= 14;

% Find columns corresponding to specified time points (in units of 100 ms)
t_minus_20= find(hmm.stimAll.neutral.time==-2);
t_minus_15= find(hmm.stimAll.neutral.time==-1.5);
t_minus_10= find(hmm.stimAll.neutral.time==-1);
t_minus_5= find(hmm.stimAll.neutral.time==-.5);
t_zero= find(hmm.stimAll.neutral.time==0);
t_plus_5= find(hmm.stimAll.neutral.time==.5);
t_plus_10= find(hmm.stimAll.neutral.time==1);
t_plus_15= find(hmm.stimAll.neutral.time==1.5);
t_plus_20= find(hmm.stimAll.neutral.time==2);

%% -----------------------------------------------------------------------
%% VISUALISATION: ALL TRIALS

% Create figure
fig=figure('color',[1 1 1],'pos',[10 10 300 300]);
fig.PaperPositionMode = 'auto';
hold on;
% Add reference lines
plot([1 57],[0 0],'k-','LineWidth',lw);
% Add stimulus
fill([t_minus_20 t_minus_20 t_minus_20+10 t_minus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_zero t_zero t_zero+10 t_zero+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_plus_20 t_plus_20 t_plus_20+10 t_plus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
% Plot data
pupil= hmm.stimAll.average.pupil;
ne= hmm.stimAll.average.ne;
plot(pupil,'--','Color','k','LineWidth',datalw);
plot(ne,'-','Color','k','LineWidth',datalw);
% Add timestamps to x-axis
my_time= [t_minus_20  t_minus_10 t_zero t_plus_10 t_plus_20];
set(gca,'XTick',my_time,'XTickLabel',{'-2','-1','0','1','2'});
xlim([t_minus_20+5 t_plus_20+5]);
% Adjust y-axis
set(gca,'YTick',-3:1.5:3);
ylim([-3 3]);
% tidy up
set(gca,'FontSize',axisFS,'LineWidth',lw);
% Add axis labels
xlabel('Time [seconds]','FontSize',labelFS);
ylabel('Estimate [{\itz} ]','FontSize',labelFS);
axis square;
% Add correlation statistics
[r p]= corrcoef(pupil,ne);
r_text= ['r = ',num2str(round(r(2)*100)/100)];
if p(2) < .001;
    p_text= ['p = < .001'];
else
    p_text= ['p = ',num2str(round(p(2)*1000)/1000)];
end
title([r_text,', ',p_text],'FontWeight','normal');
% Print
print('-djpeg','-r300',['Figures/Figure-S4-data-all-',group]);

% Create figure
fig=figure('color',[1 1 1],'pos',[10 10 300 300]);
fig.PaperPositionMode = 'auto';
hold on;
% Add reference lines
plot([1 57],[0 0],'k-','LineWidth',lw);
% Add stimulus
fill([t_minus_20 t_minus_20 t_minus_20+10 t_minus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_zero t_zero t_zero+10 t_zero+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_plus_20 t_plus_20 t_plus_20+10 t_plus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
% Plot data
hmm_corr_min= hmm.stimAll.average.corr.min;
hmm_corr_mid= hmm.stimAll.average.corr.median;
hmm_corr_max= hmm.stimAll.average.corr.max;
fillhmmCI95plotCustomColz(hmm_corr_mid,datalw,'-','k',hmm_corr_min,hmm_corr_max);
% Add timestamps to x-axis
my_time= [t_minus_20  t_minus_10 t_zero t_plus_10 t_plus_20];
set(gca,'XTick',my_time,'XTickLabel',{'-2','-1','0','1','2'});
xlim([t_minus_20+5 t_plus_20+5]);
% Adjust y-axis
set(gca,'YTick',-1:.5:1);
ylim([-1.1 1.1]);
% tidy up
set(gca,'FontSize',axisFS,'LineWidth',lw);
% Add axis labels
xlabel('Time [seconds]','FontSize',labelFS);
ylabel('HMM: Pupil-NA corr.','FontSize',labelFS);
axis square;
% Print
print('-djpeg','-r300',['Figures/Figure-S4-hmm-oddball-lowArousal-',group]);

%% -----------------------------------------------------------------------
%% VISUALISATION: LOW-AROUSAL ODDBALL

% Create figure
fig=figure('color',[1 1 1],'pos',[10 10 300 300]);
fig.PaperPositionMode = 'auto';
hold on;
% Add reference lines
plot([1 57],[0 0],'k-','LineWidth',lw);
% Add stimulus
fill([t_minus_20 t_minus_20 t_minus_20+10 t_minus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_zero t_zero t_zero+10 t_zero+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_plus_20 t_plus_20 t_plus_20+10 t_plus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
% Plot data
pupil= hmm.stimOddball.arousal_low.pupil;
ne= hmm.stimOddball.arousal_low.ne;
plot(pupil,'--','Color','k','LineWidth',datalw);
plot(ne,'-','Color',[97 180 213]./255,'LineWidth',datalw);
% Add timestamps to x-axis
my_time= [t_minus_20  t_minus_10 t_zero t_plus_10 t_plus_20];
set(gca,'XTick',my_time,'XTickLabel',{'-2','-1','0','1','2'});
xlim([t_minus_20+5 t_plus_20+5]);
% Adjust y-axis
set(gca,'YTick',-3:1.5:3);
ylim([-3 3]);
% tidy up
set(gca,'FontSize',axisFS,'LineWidth',lw);
% Add axis labels
xlabel('Time [seconds]','FontSize',labelFS);
ylabel('Estimate [{\itz} ]','FontSize',labelFS);
axis square;
% Add correlation statistics
[r p]= corrcoef(pupil,ne);
r_text= ['r = ',num2str(round(r(2)*100)/100)];
if p(2) < .001;
    p_text= ['p = < .001'];
else
    p_text= ['p = ',num2str(round(p(2)*1000)/1000)];
end
title([r_text,', ',p_text],'FontWeight','normal');
% Print
print('-djpeg','-r300',['Figures/Figure-S4-data-oddball-lowArousal-',group]);

% Create figure
fig=figure('color',[1 1 1],'pos',[10 10 300 300]);
fig.PaperPositionMode = 'auto';
hold on;
% Add reference lines
plot([1 57],[0 0],'k-','LineWidth',lw);
% Add stimulus
fill([t_minus_20 t_minus_20 t_minus_20+10 t_minus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_zero t_zero t_zero+10 t_zero+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_plus_20 t_plus_20 t_plus_20+10 t_plus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
% Plot data
hmm_corr_min= hmm.stimOddball.arousal_low.corr.min;
hmm_corr_mid= hmm.stimOddball.arousal_low.corr.median;
hmm_corr_max= hmm.stimOddball.arousal_low.corr.max;
fillhmmCI95plotCustomColz(hmm_corr_mid,datalw,'-',[97 180 213]./255,hmm_corr_min,hmm_corr_max);
% Add timestamps to x-axis
my_time= [t_minus_20  t_minus_10 t_zero t_plus_10 t_plus_20];
set(gca,'XTick',my_time,'XTickLabel',{'-2','-1','0','1','2'});
xlim([t_minus_20+5 t_plus_20+5]);
% Adjust y-axis
set(gca,'YTick',-1:.5:1);
ylim([-1.1 1.1]);
% tidy up
set(gca,'FontSize',axisFS,'LineWidth',lw);
% Add axis labels
xlabel('Time [seconds]','FontSize',labelFS);
ylabel('HMM: Pupil-NA corr.','FontSize',labelFS);
axis square;
% Print
print('-djpeg','-r300',['Figures/Figure-S4-hmm-oddball-lowArousal-',group]);

%% -----------------------------------------------------------------------
%% VISUALISATION: HIGH-AROUSAL ODDBALL

% Create figure
fig=figure('color',[1 1 1],'pos',[10 10 300 300]);
fig.PaperPositionMode = 'auto';
hold on;
% Add reference lines
plot([1 57],[0 0],'k-','LineWidth',lw);
% Add stimulus
fill([t_minus_20 t_minus_20 t_minus_20+10 t_minus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_zero t_zero t_zero+10 t_zero+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_plus_20 t_plus_20 t_plus_20+10 t_plus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
% Plot data
pupil= hmm.stimOddball.arousal_high.pupil;
ne= hmm.stimOddball.arousal_high.ne;
plot(pupil,'--','Color','k','LineWidth',datalw);
plot(ne,'-','Color',[200 105 213]./255,'LineWidth',datalw);
% Add timestamps to x-axis
my_time= [t_minus_20  t_minus_10 t_zero t_plus_10 t_plus_20];
set(gca,'XTick',my_time,'XTickLabel',{'-2','-1','0','1','2'});
xlim([t_minus_20+5 t_plus_20+5]);
% Adjust y-axis
set(gca,'YTick',-3:1.5:3);
ylim([-3 3]);
% tidy up
set(gca,'FontSize',axisFS,'LineWidth',lw);
% Add axis labels
xlabel('Time [seconds]','FontSize',labelFS);
ylabel('Estimate [{\itz} ]','FontSize',labelFS);
axis square;
% Add correlation statistics
[r p]= corrcoef(pupil,ne);
r_text= ['r = ',num2str(round(r(2)*100)/100)];
if p(2) < .001;
    p_text= ['p = < .001'];
else
    p_text= ['p = ',num2str(round(p(2)*1000)/1000)];
end
title([r_text,', ',p_text],'FontWeight','normal');
% Print
print('-djpeg','-r300',['Figures/Figure-S4-data-oddball-highArousal-',group]);

% Create figure
fig=figure('color',[1 1 1],'pos',[10 10 300 300]);
fig.PaperPositionMode = 'auto';
hold on;
% Add reference lines
plot([1 57],[0 0],'k-','LineWidth',lw);
% Add stimulus
fill([t_minus_20 t_minus_20 t_minus_20+10 t_minus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_zero t_zero t_zero+10 t_zero+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
fill([t_plus_20 t_plus_20 t_plus_20+10 t_plus_20+10], [-4 4 4 -4],'k','Edgecolor','none','FaceAlpha',.2);
% Plot data
hmm_corr_min= hmm.stimOddball.arousal_high.corr.min;
hmm_corr_mid= hmm.stimOddball.arousal_high.corr.median;
hmm_corr_max= hmm.stimOddball.arousal_high.corr.max;
fillhmmCI95plotCustomColz(hmm_corr_mid,datalw,'-',[200 105 213]./255,hmm_corr_min,hmm_corr_max);
% Add timestamps to x-axis
my_time= [t_minus_20  t_minus_10 t_zero t_plus_10 t_plus_20];
set(gca,'XTick',my_time,'XTickLabel',{'-2','-1','0','1','2'});
xlim([t_minus_20+5 t_plus_20+5]);
% Adjust y-axis
set(gca,'YTick',-1:.5:1);
ylim([-1.1 1.1]);
% tidy up
set(gca,'FontSize',axisFS,'LineWidth',lw);
% Add axis labels
xlabel('Time [seconds]','FontSize',labelFS);
ylabel('HMM: Pupil-NA corr.','FontSize',labelFS);
axis square;
% Print
print('-djpeg','-r300',['Figures/Figure-S4-hmm-oddball-highArousal-',group]);