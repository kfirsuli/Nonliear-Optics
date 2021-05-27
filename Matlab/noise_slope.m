function [ noise_slope ] = noise_slope( roundtrip_length,pulses_loc,pulses_pow,pow_factor,noise_calc_factor,l,g_,s )
%noise_slope returns the noise derivative at pulses_loc.

start_cavity=min(pulses_loc)-0.01; % Setting the beginning of the cavity, in order to "follow" the pulses
gain_int=gain_integral( roundtrip_length,pulses_loc,pulses_pow,pow_factor,start_cavity); % calculating gain integral

m=0.00001; 

noise_slope=zeros(1,length(pulses_loc));
for j=1:length(pulses_loc) % calculating derivative for all pulses
    %% Moving a specific pulse
    pulse_move=zeros(1,length(pulses_loc));
    pulse_move(j)=s; % pulse movement for derivative calculation
    %% Calculating the noise when the pulse is moved to the right
    gain_before1 = gain_value(roundtrip_length,pulses_loc+pulse_move,pulses_pow,pow_factor,pulses_loc(j)+pulse_move(j)-m,g_,start_cavity,gain_int);
    gain_after1 = gain_value(roundtrip_length,pulses_loc+pulse_move,pulses_pow,pow_factor,pulses_loc(j)+pulse_move(j)+m,g_,start_cavity,gain_int);
    noise_after=noise_value(gain_before1,gain_after1,noise_calc_factor,l);
    %% Calculating the noise when the pulse is moved to the left
    gain_before2=gain_value(roundtrip_length,pulses_loc-pulse_move,pulses_pow,pow_factor,pulses_loc(j)-pulse_move(j)-m,g_,start_cavity,gain_int);
    gain_after2=gain_value(roundtrip_length,pulses_loc-pulse_move,pulses_pow,pow_factor,pulses_loc(j)-pulse_move(j)+m,g_,start_cavity,gain_int);
    noise_before=noise_value(gain_before2,gain_after2,noise_calc_factor,l); 
    %% Estimating the derivative
    noise_slope(j)= (noise_after-noise_before)/(2*s); % Derivative calculation
end

end

