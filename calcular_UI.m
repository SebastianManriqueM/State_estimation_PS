function [ UI, erro_est ]     = calcular_UI( num_medidas, H, iG, W, residuo_N )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
UI       = zeros(num_medidas, 1);
erro_est = zeros(num_medidas, 1);
K        = H * iG * H' * W;
%K  = h./z;

for i = 1 : num_medidas
    a = K(i,i);
    b = 1- K(i,i);
    if abs(a) < 1e-14
        a = abs(a);
    elseif abs(b) < 1e-14
        b = abs(b);
    end
        
    UI(i) = sqrt( a )/ sqrt( b );
    
    erro_est(i) = residuo_N(i) * sqrt( UI(i)^2 + 1 );
end

end

