% Bang et al (2023) Noradrenaline tracks emotional modulation of attention
% in human amygdala
%
% Figure S2A
%
% Plots normative ratings and illuminance for IAPS images
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
dirDataI= [dirBase,fs,'Data',fs,'Images']; % IAPS

% Load data
load([dirDataI,fs,'IAPS_image_info.mat']);

%% -----------------------------------------------------------------------
%% NORMATIVE

% General specifications
alphaz= .6;
lw= 2;
factor= 4;
datalw= 2;
axisFS= 20+factor;
labelFS= 24+factor;
titleFS= 16;
ms= 12;
colz_grid= ones(1,3).*.4;
lw_grid= .5;
marker_col= [255 110 0]./255;

% Prepare figure
fig=figure('color',[1 1 1],'pos',[10 10 280 300]);
fig.PaperPositionMode = 'auto';
hold on;
% % grid
v_ref=[2:1:8];
for i_ref= 1:length(v_ref);
    plot([1.1 8.9], [v_ref(i_ref) v_ref(i_ref)],'k--','color',colz_grid,'LineWidth',lw_grid);
    plot([v_ref(i_ref) v_ref(i_ref)],[1.1 8.9],'k--','color',colz_grid,'LineWidth',lw_grid);
end
% negative-low
x= iaps.arousal_rating(iaps.valence_category==-1 & iaps.arousal_category==-1);
y= iaps.valence_rating(iaps.valence_category==-1 & iaps.arousal_category==-1);
plot(x,y,'d','color',[1 1 1],'markerfacecolor',[234 156 157]./255,'markersize',ms);
% negative-high
x= iaps.arousal_rating(iaps.valence_category==-1 & iaps.arousal_category==+1);
y= iaps.valence_rating(iaps.valence_category==-1 & iaps.arousal_category==+1);
plot(x,y,'o','color',[1 1 1],'markerfacecolor',[255 89 92]./255,'markersize',ms);
% positive-low
x= iaps.arousal_rating(iaps.valence_category==+1 & iaps.arousal_category==-1);
y= iaps.valence_rating(iaps.valence_category==+1 & iaps.arousal_category==-1);
plot(x,y,'d','color',[1 1 1],'markerfacecolor',[148 229 152]./255,'markersize',ms);
% positive-high
x= iaps.arousal_rating(iaps.valence_category==+1 & iaps.arousal_category==+1);
y= iaps.valence_rating(iaps.valence_category==+1 & iaps.arousal_category==+1);
plot(x,y,'o','color',[1 1 1],'markerfacecolor',[93 241 97]./255,'markersize',ms);
% % % neutral
x= iaps.arousal_rating(iaps.valence_category==0 & iaps.arousal_category==0);
y= iaps.valence_rating(iaps.valence_category==0 & iaps.arousal_category==0);
plot(x,y,'s','color',[1 1 1],'markerfacecolor',[102 102 255]./255,'markersize',ms);
% tidy up
set(gca,'FontSize',axisFS,'LineWidth',lw);
set(gca,'XTick',[2:2:8],'YTick',[2:2:8]);
xlim([1 9]);
ylim([1 9]);
% add axis labels
xlabel('Arousal','FontSize',labelFS);
ylabel('Valence','FontSize',labelFS);
% box
box on;
axis square;
% Print figure
print('-djpeg','-r300',['Figures/Figure-S2A-normative']);

%% -----------------------------------------------------------------------
%% ILLUMINANCE

% General specifications
% Color
colz_neg= [1 .4 .4];
colz_pos= [.2 1 .2];
colz_low= [38 214 248]./255;
colz_high= [248 104 246]./255;
colz_neu= [191 191 191]./255;
% Rest
alphaz= 1;
lw= 2;
datalw= 2;
axisFS= 20;
labelFS= 24;
titleFS= 16;
ms= 14;
colz=  [234 156 157; ...
        255 89 92; ...
        148 229 152;...
        93 241 97;...
        102 102 255]./255;

% Create figure
fig=figure('color',[1 1 1],'pos',[10 10 300 300]);
fig.PaperPositionMode = 'auto';
hold on;
% Plot data
i_bar= 0;
% negative-low
dat= iaps.illuminance(iaps.valence_category==-1 & iaps.arousal_category==-1);
mu= mean(dat);
se= std(dat)./sqrt(length(dat));
i_bar= i_bar+1;
plot([i_bar i_bar],[mu-se mu+se],'k-','LineWidth',2);
plot(i_bar,mu,'ko','MarkerFaceColor',colz(i_bar,:),'MarkerSize',10,'LineWidth',2);
% negative-high
dat= iaps.illuminance(iaps.valence_category==-1 & iaps.arousal_category==+1);
mu= mean(dat);
se= std(dat)./sqrt(length(dat));
i_bar= i_bar+1;
plot([i_bar i_bar],[mu-se mu+se],'k-','LineWidth',2);
plot(i_bar,mu,'ko','MarkerFaceColor',colz(i_bar,:),'MarkerSize',10,'LineWidth',2);
% positive-low
dat= iaps.illuminance(iaps.valence_category==+1 & iaps.arousal_category==-1);
mu= mean(dat);
se= std(dat)./sqrt(length(dat));
i_bar= i_bar+1;
plot([i_bar i_bar],[mu-se mu+se],'k-','LineWidth',2);
plot(i_bar,mu,'ko','MarkerFaceColor',colz(i_bar,:),'MarkerSize',10,'LineWidth',2);
% positive-high
dat= iaps.illuminance(iaps.valence_category==+1 & iaps.arousal_category==+1);
mu= mean(dat);
se= std(dat)./sqrt(length(dat));
i_bar= i_bar+1;
plot([i_bar i_bar],[mu-se mu+se],'k-','LineWidth',2);
plot(i_bar,mu,'ko','MarkerFaceColor',colz(i_bar,:),'MarkerSize',10,'LineWidth',2);
% neutral
dat= iaps.illuminance(iaps.valence_category==0 & iaps.arousal_category==0);
mu= mean(dat);
se= std(dat)./sqrt(length(dat));
i_bar= i_bar+1;
plot([i_bar i_bar],[mu-se mu+se],'k-','LineWidth',2);
plot(i_bar,mu,'ko','MarkerFaceColor',colz(i_bar,:),'MarkerSize',10,'LineWidth',2);
% tidy up
set(gca,'FontSize',axisFS,'LineWidth',lw);
set(gca,'XTick',[]);
xlim([0 6]);
ylim([10 16]);
xlabel('IAPS category','FontSize',labelFS);
ylabel('Illuminance [lux]','FontSize',labelFS);
axis square;
% Print
print('-djpeg','-r300',['Figures/Figure-S2A-illuminance']);