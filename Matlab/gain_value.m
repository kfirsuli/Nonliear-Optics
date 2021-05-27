function [  gain_in_pos ] = gain_value( roundtrip_length,pulses_loc,pulses_pow,pow_factor,eval_loc,g_,start1,gain_integral)
%gain_value returns the gain at the point specified in eval_loc

slope = (pow_factor*(sum(pulses_pow)))/roundtrip_length; %Calculating the gain's slope


gain_in_pos = (eval_loc-start1)*slope-...
    sum(pow_factor*(heaviside(eval_loc-pulses_loc).*pulses_pow));
gain_in_pos=gain_in_pos-gain_integral/roundtrip_length+g_/roundtrip_length;

end

