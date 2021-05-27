function [ gain_int ] = gain_integral( roundtrip_length,pulses_loc,pulses_pow,pow_factor,start1)
%gain_integral calculates the gain integral along the cavity

slope = (pow_factor*(sum(pulses_pow)))/roundtrip_length; %Calculating the gain's slope
step_gain=0.01;

vec=[start1:step_gain:(roundtrip_length+start1)]; %Locations vector
gain= zeros(1,length(vec));

for i=vec
    gain(round((i-start1)*(1/step_gain)+1)) = ((i-start1)*slope-...
    sum(pow_factor*(heaviside(i-pulses_loc).*pulses_pow)));
end
gain_int=trapz(vec,gain);


end

