function [ H_col ] = app_fatores_tri( Fatores, H_col )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i = 2 : size(Fatores, 1)
    for j = 1 : i-1
        H_col(i) = (Fatores(i,j) * H_col(j)) + H_col(i);
    end
    
end
    

end

