%  <ESTIMADOR DE ESTADOS MQP N?O LINEAR - NON LINEAR WMS STATE ESTIMATION V1.0. 
%  This is the main source of this software that estimates the sates of a power network (complex voltages at nodes) described using an excel input data file >
%     Copyright (C) <2017>  <Sebasti?n de Jes?s Manrique Machado>   <e-mail:sebastiand@utfpr.edu.br>
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

%ESTIMADOR DE ESTADOS N?O LINEAR MQP
%   Sebasti?n de Jes?s Manrique Machado
%   Estudante_Doutorado Em Engenharia El?trica
%   EESC/USP - 2017.


function [P_base, V_base, num_linhas, num_barras, num_medidas, num_pmedidas, Dados_linhas, Dados_medidas, Dados_pmedidas] = ler_dados(nome_sis)
%||  Ler dados ||
%================
Valrs_base  = xlsread(nome_sis, 'Hoja1', 'B1:B4');                   %Por enquanto n?o ingresar ao programa barras slack com cergas 
P_base      = Valrs_base(1);
V_base      = Valrs_base(2);
num_linhas  = uint8(Valrs_base(3));                                  %Convertir a valor inteiro sem signo
num_medidas = uint8(Valrs_base(4)); 
num_pmedidas= uint8(xlsread(nome_sis, 'Hoja1', 'E4:E4'));
flag_pu    = xlsread(nome_sis, 'Hoja1', 'E1:E1');                                 
clear Valrs_base;

Dados_linhas = xlsread(nome_sis, 'Hoja1', strcat( 'A8:E',num2str(num_linhas+7) ));

vetor_aux  = unique([Dados_linhas(:,1) ; Dados_linhas(:,2)].');     % Coloca em ordem ascendente e sem repetir; Transpuesto
num_barras = length(vetor_aux);                                     % Conhecer num de barras

%---------------------------------------------------------------------------------------------------------------------
Dados_medidas = xlsread(nome_sis, 'Hoja1', strcat( 'A',num2str(num_linhas+10),':E',num2str(num_linhas+10+num_medidas) ));
%||  Colocar Pot?ncias em p.u. ||
% if(~flag_pu)
%     Dados_medidas(:, [3,4,5,6]) = (1/P_base)*Dados_medidas(:, [3,4,5,6]);
% end

%---------------------------------------------------------------------------------------------------------------------
Dados_pmedidas = xlsread(nome_sis, 'Hoja1', strcat( 'A',num2str(num_linhas+num_medidas+13),':E',num2str(num_linhas+num_medidas+13+num_pmedidas) ));
clear flag_pu;
%---------------------------------------------------------------------------------------------------------------------

end
