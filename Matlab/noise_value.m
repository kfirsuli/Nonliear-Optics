function [ noise ] = noise_value( gain_before,gain_after,noise_calc_factor,l)
%noise_value returns the noise at the point between the points ot gain
%before and after. The calculation is based on supplementary material in
%Omri Gat's paper eq S20
noise = noise_calc_factor * (1/sqrt(l-gain_before) + 1/sqrt(l-gain_after));
end

