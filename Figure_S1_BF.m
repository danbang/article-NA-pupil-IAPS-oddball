% Bang et al (2023) Noradrenaline tracks emotional modulation of attention
% in human amygdala
%
% Reproduces Figure S1: Behnke-Fried electrodes
%
% Plots calibration data for DA, 5-HT, and NE
%
% Dan Bang danbang@cfin.au.dk 2023

%% -----------------------------------------------------------------------
%% PREPARATION

% Fresh memory
clear;

% Paths [change 'dirBase' according to local setup]
fs= filesep;
dirBase= getIAPS;
dirDataB= [dirBase,fs,'Data',fs,'Patients',fs,'Behaviour']; % behaviour
dirDataC= [dirBase,fs,'Data',fs,'Patients',fs,'Calibration']; % in-vitro calibration
dirDataP= [dirBase,fs,'Data',fs,'Patients',fs,'Pupil']; % pupillometry
dirDataV= [dirBase,fs,'Data',fs,'Patients',fs,'Voltammetry']; % voltammetry

% Custom functions
addpath('Functions');

% Electrode
electrode= 'BF'; % Behnke-Fried

% Subjects
n_sbj= 3;

% NT indices (for reading from .csv files)
i_da= 1;
i_se= 2;
i_ph= 3;
i_ne= 4;
v_nt= [1 2 4];

%% -----------------------------------------------------------------------
%% RUN

% Loop through subjects
for i_sbj= 1:n_sbj;
    
    % Load calibration data
    c_true_matrix= csvread([dirDataC,fs,electrode,'_',num2str(i_sbj),'_true.csv']);
    c_pred_matrix= csvread([dirDataC,fs,electrode,'_',num2str(i_sbj),'_prediction.csv']);
    
    % Identify mixture and non-mixture samples
    c_true_matrix_no_pH= [c_true_matrix(:,i_da) c_true_matrix(:,i_se) c_true_matrix(:,i_ne)];
    samp_idx_mix= sum(c_true_matrix_no_pH>0,2)>1;
    samp_idx_zero= sum(c_true_matrix_no_pH>0,2)==0;
    samp_idx_nonmix= (samp_idx_mix+samp_idx_zero)==0;
    
    % Loop through data
    for i_true= 1:3;
        for i_prediction= 1:3;
            % Non-mixtures
            % Compute summary statistics
            X_val= c_true_matrix(samp_idx_nonmix,v_nt(i_true));
            Y_val= c_pred_matrix(samp_idx_nonmix,v_nt(i_prediction));
            X_unq= sort(unique(X_val),'ascend');
            X_unq= X_unq(X_unq~=0);
            clear tmp;
            tmp.mu= [];
            tmp.se= [];
            tmp.sd= [];
            tmp.ci= [];
            for i_x_unq= 1:length(X_unq);
                c_idx= find(X_val==X_unq(i_x_unq));
                c_n= length(c_idx);
                tmp.xv(i_x_unq)= X_unq(i_x_unq);
                tmp.mu(i_x_unq)= mean(Y_val(c_idx));
                tmp.se(i_x_unq)= std(Y_val(c_idx))/sqrt(c_n);
                tmp.sd(i_x_unq)= std(Y_val(c_idx));
                tmp.ci(i_x_unq)= 1.96*(std(Y_val(c_idx))/sqrt(c_n));             
            end
            calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_prediction}.xv= tmp.xv;
            calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_prediction}.mu= tmp.mu;
            calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_prediction}.se= tmp.se;
            calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_prediction}.sd= tmp.sd;
            calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_prediction}.ci= tmp.ci;
            % Mixtures
            % Compute summary statistics
            X_val= c_true_matrix(samp_idx_mix,v_nt(i_true));
            Y_val= c_pred_matrix(samp_idx_mix,v_nt(i_prediction));
            X_unq= sort(unique(X_val),'ascend');
            X_unq= X_unq(X_unq~=0);
            clear tmp;
            tmp.mu= [];
            tmp.se= [];
            tmp.sd= [];
            tmp.ci= [];
            for i_x_unq= 1:length(X_unq);
                c_idx= find(X_val==X_unq(i_x_unq));
                c_n= length(c_idx);
                tmp.xv(i_x_unq)= X_unq(i_x_unq);
                tmp.mu(i_x_unq)= mean(Y_val(c_idx));
                tmp.se(i_x_unq)= std(Y_val(c_idx))/sqrt(c_n);
                tmp.sd(i_x_unq)= std(Y_val(c_idx));
                tmp.ci(i_x_unq)= 1.96*(std(Y_val(c_idx))/sqrt(c_n));             
            end
            calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_prediction}.xv= tmp.xv;
            calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_prediction}.mu= tmp.mu;
            calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_prediction}.se= tmp.se;
            calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_prediction}.sd= tmp.sd;
            calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_prediction}.ci= tmp.ci;
        end
    end
    
end

%% -----------------------------------------------------------------------
%% VISUALISATION

% General specifications
colz_nt= [100 100 255; ...
          255 100 100; ...
          0 225 0]./255;
colz_grid= ones(1,3).*.4;
lw= 4;
lw_grid= .5;
lw_id= 2;
axisFS= 22;
labelFS= 30;
chem_names= {'DA','5-HT','NA'};

% FIGURE: GROUP-LEVEL RESULTS
% Loop through NTs: predicted
for i_pred= 1:3;
    % Create figure
    figure('color',[1 1 1]);
    hold on;
    % Add reference lines
    % Identity
    plot([-500 2500],[-500 2500],'k-','LineWidth',lw_id);
    % Grid
    v_ref=[0:500:2000];
    for i_ref= 1:length(v_ref);
        plot([-450 2450], [v_ref(i_ref) v_ref(i_ref)],'k--','color',colz_grid,'LineWidth',lw_grid);
        plot([v_ref(i_ref) v_ref(i_ref)],[-450 2450],'k--','color',colz_grid,'LineWidth',lw_grid);
    end
    % Loop through NTs: true
    for i_true= 1:3;
        xv_sin= []; % sin = single-analyte sample
        mu_sin= [];
        ci_sin= [];
        xv_mix= []; % mix = mixture-analyte sample
        mu_mix= [];
        ci_mix= [];
        xv_all= []; % all = both sample types
        mu_all= [];
        ci_all= [];
        % Loop through subjects
        for i_sbj= 1:3;
           xv_sin= [xv_sin calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_pred}.xv];
           mu_sin= [mu_sin calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_pred}.mu];
           ci_sin= [ci_sin calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_pred}.ci];
           if i_pred==i_true
               xv_mix= [xv_mix calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.xv(calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.xv~=0)];
               mu_mix= [mu_mix calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.mu(calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.xv~=0)];
               ci_mix= [ci_mix calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.ci(calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.xv~=0)];
               xv_all= [xv_all calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_pred}.xv calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.xv(calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.xv~=0)];
               mu_all= [mu_all calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_pred}.mu calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.mu(calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.xv~=0)];
               ci_all= [ci_all calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_pred}.ci calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.ci(calibration_stats.subject{i_sbj}.mix.true{i_true}.prediction{i_pred}.xv~=0)];
           else 
               xv_all= [xv_all calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_pred}.xv];
               mu_all= [mu_all calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_pred}.mu];
               ci_all= [ci_all calibration_stats.subject{i_sbj}.nonmix.true{i_true}.prediction{i_pred}.ci];
           end
        end
        % Plot data
        for i_x= 1:length(xv_sin);
           plot([xv_sin(i_x) xv_sin(i_x)],[mu_sin(i_x)-ci_sin(i_x) mu_sin(i_x)+ci_sin(i_x)],'-','Color',colz_nt(i_true,:));
        end
        plot(xv_sin, mu_sin, 'o','color','w','MarkerFaceColor',colz_nt(i_true,:),'MarkerSize',10);
        for i_x= 1:length(xv_mix);
           plot([xv_mix(i_x) xv_mix(i_x)],[mu_mix(i_x)-ci_mix(i_x) mu_mix(i_x)+ci_mix(i_x)],'-','Color',colz_nt(i_true,:));
        end
        plot(xv_mix, mu_mix, 'd','color','k','MarkerFaceColor',colz_nt(i_true,:),'MarkerSize',10);
        % Run regression
        glmhat{i_pred,i_true}= fitglm(xv_all,mu_all);
    end
    % Tidy up
    set(gca,'XTick',[-500:500:2500],'YTick',[-500:500:2500])
    set(gca,'FontSize',axisFS,'LineWidth',lw);
    xlabel('True NA or DA or 5-HT [nM]','FontSize',labelFS);
    ylabel(['Predicted ',chem_names{i_pred},' [nM]'],'FontSize',labelFS);
    title('Behnke-Fried','FontWeight','normal','FontSize',labelFS);
    set(gca,'LineWidth',4);
    xlim([-500 2500]);
    ylim([-500 2500]);
    box on;
    axis square;
    % Print
    print('-djpeg','-r300',['Figures/Figure-1C-MM-',chem_names{i_pred}]);
end