
%% Setting parameters
clear all
pow_factor=0.1; % Determines pulse effect on gain
roundtrip_length=1; % Cavity length
s=0.0001; % Derivative step
merging_factor=0.8; 
noise_calc_factor = 0.002; % Factor in Supplementary eq S20 
pulses_loc=[0.1,0.7,0.75]; pulses_pow=[0.8,0.2,0.1]; % Pulses parameters
[pulses_loc,I]=sort(pulses_loc); pulses_pow=pulses_pow(I); 
l=1; % Loss
g_=0.9; % Small signal gain
N=500; % Number of steps
prox=0.01; %proximity threshold
dt=0.001; %Resulotion of 2d map-fast time
fast_time=[0:dt:1]; % Fast time vector
slow_time=[1:1:N];  % slow time vector(step number)
map=zeros(N,length(fast_time))+0.000001; % initiating the map with zeros (almost zeros to allow log scale)

%% Calculate noise derivative and pulses motion
i=1;  
j=1;  %combinations index
n=1;  % Step index
graph_stitch=0;
while (n<N+2 && length(pulses_pow)>1)
noise_der=noise_slope(roundtrip_length,pulses_loc(i,:),pulses_pow,pow_factor,noise_calc_factor,l,g_,s); % calculating the derivative(eq 3 Omri's paper)
pulses_loc(i+1,:)=pulses_loc(i,:)+0.5*noise_der; %calculating pulses new locations
%% 2d map
    pulses_loc_map=pulses_loc(i,:)-min(pulses_loc(i,:));
    map(n,round(pulses_loc_map/dt)+1)=pulses_pow;

i=i+1;
%% Ploting the data and combining pulses if they collide
if (min(abs(diff(pulses_loc(i,:))))<prox || (pulses_loc(i,end)- pulses_loc(i,1))>(1-prox)) %Checking for collision
%    Plot_data(pulses_loc,pulses_pow,graph_stitch) %Ploting the data so far
%    graph_stitch=i-1; % Parameter for stitching the graph properly
if length(pulses_pow)>2
    if (pulses_loc(i,end)- pulses_loc(i,1))>(1-prox) %Pulses approch distance=1
        a=1;
        I=1;
    else %pulses approch distance=0
        a=0;
        I=[find(abs(diff(pulses_loc(i,:))<prox))];
    end
   
   k=1;
   while k<length(pulses_loc(i,:))+1
       if min(abs(k-I))==0 
           if a==0
            temp_loc(k)=pulses_loc(i,k);
            temp_pow(k)=(pulses_pow(k)+pulses_pow(k+1))*merging_factor;
            k=k+1;
           else
            temp_loc(k)=pulses_loc(i,k);
            temp_pow(k)=(pulses_pow(k)+pulses_pow(end))*merging_factor;
            pulses_loc(i,end)=0;
           end
       else
           temp_loc(k)=pulses_loc(i,k); 
           temp_pow(k)=pulses_pow(k);
       end
   k=k+1;
   end
 clear pulses_loc pulses_pow I i
 i=1;
 pulses_loc=nonzeros(temp_loc)';  pulses_pow=nonzeros(temp_pow)';
[pulses_loc,m]=sort(pulses_loc); pulses_pow=pulses_pow(m); 
  clear temp_pow temp_loc m a
else
 break %Ending the simulation if there is one pulse left
end
end

%% Movie Representation
  figure(3)
    plot(pulses_loc(i,:)-min(pulses_loc(i,:)),pulses_pow,'o','MarkerFaceColor',[0 0.447058826684952 0.74117648601532])
    xlim([0,1])
    ylim([0,1])
    pause(0.00001)
    ylabel('Power (a.u.)');
    xlabel('Normelized position');
    mov(n)=getframe(gcf);
n=n+1;
end
a=menu('save video?','yes','no');
if a==1
 name=inputdlg('Insert movie name');
%Create AVI file.
myVideo = VideoWriter(name{1});
myVideo.FrameRate = n/5;  % Default 30
% myVideo.Quality = 50;    % Default 75
open(myVideo);
writeVideo(myVideo, mov);
close(myVideo);
% movie2avi(mov, '193_2_movie.avi');
end
figure(6)
mesh(fast_time,slow_time,map)
xlabel('Fast time (a.u.)')
ylabel('Slow time (a.u.)')
zlabel('Power')

