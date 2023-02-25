%  <ESTIMADOR DE ESTADOS MQP NÃO LINEAR - NON LINEAR WMS STATE ESTIMATION V1.0. 
%  This is the main source of this software that estimates the sates of a power network (complex voltages at nodes) described using an excel input data file >
%     Copyright (C) <2017>  <Sebastián de Jesús Manrique Machado>   <e-mail:sebastiand@utfpr.edu.br>
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

%ESTIMADOR DE ESTADOS NÃO LINEAR MQP
%   Sebastián de Jesús Manrique Machado
%   Estudante_Doutorado Em Engenharia Elétrica
%   EESC/USP - 2017.
%Função para imprimir arquivo de texto.

function imprimir_res( num_barras, num_linhas, num_medidas, tipo_m, Jx, no_l_i, no_l_j, no_m_i, no_m_j, z, h, v_barras, delt_barras, z_m_h, residuo_N, UI, erro_est, P_base, V_base, cont, nome_sis )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%------------------------------------------------
%|||||||    Impresão dados de Entrada    |||||||
%------------------------------------------------
tex=fopen(['Resultado_EE_NL_', nome_sis,'-', 'MQP', '.txt'],'w');                  %Abro arquivo de texto
fprintf(tex, '========================================\r\n');
fprintf(tex, '|||||   DADOS BÁSICOS DE ENTRADA   |||||\r\n');
fprintf(tex, '========================================\r\n\r\n');
fprintf(tex,strcat('\r\tData: ', datestr(now), '\r\n\r\n'));
fprintf(tex,strcat('\r\tNome do sistema: ', nome_sis,'\r\n') );
fprintf(tex,strcat('\r\tMétodo Usado: ', 'MQP','\r\n') );
fprintf(tex,strcat('\r\tPotência base= ', num2str(P_base), 'MW', '\r\t', 'Tensão Base= ', num2str(V_base),'kV', '\r\n') );
fprintf(tex,strcat('\r\tBarras= ', num2str(num_barras), '\r\t', '\r\n') );
fprintf(tex,strcat('\r\tNumero de Linhas: ', num2str(num_linhas),'\r\n\r\n') );
fprintf(tex,strcat('\r\tNumero de Medidas: ', num2str(num_medidas),'\r\n\r\n') );
fprintf(tex,strcat( '\r\tITERAÇÕES =  ', num2str(cont), '\r\n\r\n\r\n' ));
fprintf(tex,strcat( '\r\tVALOR FUNÇÃO OBJETIVO J(x) =  ', num2str(Jx), '\r\n\r\n\r\n' ));
%:::::::::::::::::::::::::::::::::::::::::::::::::::

%------------------------------------------------
%|||||||    Impresão Resultados Linhas    |||||||
%------------------------------------------------

fprintf(tex, '===================================\r\n');
fprintf(tex, '|||||   RESULTADOS RESÍDUOS   |||||\r\n');
fprintf(tex, '===================================\r\n\r\n');
fprintf(tex, 'Tipo\r\tBus i\r\tBus j\r\t\r\tMedida [pu]\r\tEstimada [pu]\r\tResíduo [pu] \r\tResíduo N [pu] \r\t  UI    \r\t  b^  \r\n\r\n' );

for i = 1 : num_medidas
    fprintf(tex,'%3.1f\r\t %3.1f\r\t  %3.1f\r\t %12.4f\r\t   %12.4f\r\t   %12.4f\r\t   %12.4f\r\t  %12.4f\r\t %12.4f\r\n',tipo_m(i), no_m_i(i), no_m_j(i), z(i), h(i), z_m_h(i), residuo_N(i), UI(i), erro_est(i) );
end

%------------------------------------------------
%|||||||    Impresão Resultados Barras    |||||||
%------------------------------------------------

delt_barras = delt_barras - ( round( delt_barras./(2*pi) ) *2*pi() );
fprintf(tex, '\r\n\r\n\r\n===================================\r\n');
fprintf(tex, '|||||   RESULTADOS V ESTADO   |||||\r\n');
fprintf(tex, '===================================\r\n\r\n');
fprintf(tex, 'Bus i\r\t\r\tV [p.u.]\r\tdelta [º]\r\n\r\n' );
for i = 1 : num_barras
    fprintf(tex,'%3.1f\r\t %12.4f\r\t  %12.4f\r\n', i, v_barras(i), radtodeg(delt_barras(i)) ); 
end
