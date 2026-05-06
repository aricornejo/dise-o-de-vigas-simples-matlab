function [As_min, M_max, resultados] = flexion(fc, fy, b, d, Mu)
% Calculo de acero en viga de hormigon armado
% Unidades declaradas:
% fc = MPa
% fy = MPa
% b y d = m
% Mu = KN/m (puede ser un vector con varios momentos)

% Cálculo de beta 1 según la resistencia del hormigón
if fc <= 28
    beta1 = 0.85;
elseif fc < 55
    beta1 = 0.85 - 0.05 * (fc - 28) / 7;
else
    beta1 = 0.65;
end

% Cuantia maxima y Acero maximo
p_max = 0.85 *beta1 *(fc/fy) * (0.003/0.008);
As_max = p_max * b * d; 

% Momento Maximo resistente en MN/m
M_max = 0.9 * As_max * fy * (d - (As_max * fy) / (2 * 0.85 * fc * b));

% Acero minimo
As_min = max ([(fc^0.5*b*d)/(4*fy); (1.4*b*d/fy)]); 

% Conversión del momento ultimo de kN/m a MN/m
Mu = Mu / 1000;
%Variable temporal 
temp = size(Mu);
% Numero de Momentos Ultimos 
NoMu= temp(2);
resultados= cell(NoMu,2);

for i = 1:NoMu

        % Determinación de la cantidad de momentos ingresados
        if Mu(i)> M_max
        % Usamos llaves {} y asignamos el texto a la columna 2
         resultados {i,1} = 0;
         resultados {i,2}= 'INCREMENTAR VIGA O ANCHO DE LA VIGA';
          
        else 
          As = (0.9 * d - (0.81 * d^2 - 1.8 * Mu(i) / (0.85 * fc * b))^ 0.5) / (0.9 * fy / (0.85 * fc * b));

        % Usamos llaves {} para guardar el resultado del acero y el texto
          resultados {i,1} = max([As As_min]);
          resultados {i,2}='CALCULO OK';

        end
end
M_max= M_max * 1000;

end