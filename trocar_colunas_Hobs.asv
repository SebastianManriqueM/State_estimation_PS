function [ H_obs, i ] = trocar_colunas_Hobs( H_obs, fila )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%Hcol = zeros( size(H_obs, 1), 1 );
ncol = size(H_obs, 2);
for i = fila + 1 : ncol
    if H_obs( fila:fila ,i:i ) ~= 0
        Hcol                       = H_obs( : , i:i );
        H_obs( : , i:i ) = H_obs( : , fila:fila );
        H_obs( : , fila:fila )     = Hcol;
        break;
    end
end

end

