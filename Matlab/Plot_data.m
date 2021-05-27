function [  ] =Plot_data( pulses_loc,pulses_pow,j )
%Plotting the data
%% Ploting distance of each pulse from the first vs time 
figure(1)
for t=2:length(pulses_loc(1,:))
hold on
plot([1:1:length(pulses_loc(1:end-1,t))]+j,(pulses_loc(1:end-1,t)-pulses_loc(1:end-1,1)))
xlabel('Step (slow time)')
ylabel('Distance between pulses')
title('Distance between pulses vs steps (slow time)')
hold on
set(gca,'fontsize',16)
ylim([0,1])
end
hold off

%% Ploting pulses locations vs time 
figure(2)
for t=1:length(pulses_loc(1,:))
hold on
plot([1:1:length(pulses_loc(1:end-1,t))]+j,pulses_loc(1:end-1,t))
xlabel('Step (slow time)')
ylabel('Pulse location (fast time)')
title('Pulses locations (fast time) vs step (slow time)')
hold on
set(gca,'fontsize',16)
end
hold off

% %% Movie Representation
%   figure(3)
% for f=1:length(pulses_loc(:,1))-2
%     plot(pulses_loc(f,:)-min(pulses_loc(f,:)),pulses_pow,'o','MarkerFaceColor',[0 0.447058826684952 0.74117648601532])
%     xlim([0,1])
%     ylim([0,1])
% %     pause(0.005)
%    
% end

end

