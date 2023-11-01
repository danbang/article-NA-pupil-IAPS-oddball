function h = fillhmmCI95plotCustomColz(mu,linewid,linez,colz,ci_min,ci_max)
% function h = fillhmmCI95plotCustomColz(mu,linewid,linez,colz,ci_min,ci_max)

% plot mean
hold on; 
plot(mu,'color',colz,'LineWidth',linewid,'linestyle',linez);
% plot 95 CI
hh = [];
xn = 1:length(ci_min);
for i = 1:length(ci_min)-1
    hold on;
    yplus1 = ci_max(i);
    yplus2 = ci_max(i+1);
    yminus1 = ci_min(i);
    yminus2 = ci_min(i+1);
    hh(end+1) = fill([xn(i) xn(i) xn(i+1) xn(i+1)],[yminus1 yplus1 yplus2 yminus2],colz,'Edgecolor','none','FaceAlpha',.3);
end
        
return