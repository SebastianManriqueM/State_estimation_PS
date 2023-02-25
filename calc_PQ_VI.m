function [ V_complejo, I_inj, S_calc, P_calc, Q_calc ] = calc_PQ_VI( v_barras, delt_barras, Y_barras )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

 V_complejo  = v_barras.* cos(delt_barras) + 1i * v_barras.* sin(delt_barras);   % Não é produto matrizial. Produto termo a termo
 I_inj  = Y_barras * V_complejo;
 S_calc = V_complejo.* conj(I_inj);                                              % Não é produto matrizial. Produto termo a termo
 P_calc = real(S_calc);
 Q_calc = imag(S_calc);

end

