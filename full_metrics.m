%{
-------------------------------------------------------------------------------
TÍTULO: full_metric.m
-------------------------------------------------------------------------------
AUTOR:     Pedro Moreira
DATA:      30/11/2025
VERSÃO:    [1.0]
VERSÃO MATLAB: R2016
-------------------------------------------------------------------------------
DESCRIÇÃO/OBJETIVO:
    Este módulo é responsável por gerar a plotagem das métricas de síntese lógica.
-------------------------------------------------------------------------------
%}
function plot_resultados_separados

K_vec = 1:8;

Freq_Hz = 367.65e6; 

% Modificar com os dados gerados do descomprime.m e da síntese lógica %
Power_DWT = [1.536e-5, 1.390e-5, 1.230e-5, 1.066e-5, ...
             0.908e-5, 0.763e-5, 0.629e-5, 0.497e-5];
         
% Modificar com os dados gerados do descomprime.m e da síntese lógica %
Area_DWT  = [1157.09, 1078.14, 995.93, 913.72, ...
             831.52,  749.31,  667.10, 584.89];

Energia_DWT = Power_DWT * Freq_Hz;

% Modificar com os dados gerados do descomprime.m e da síntese lógica %
Power_IDWT = [4.036e-5, 3.578e-5, 3.033e-5, 2.419e-5, ...
              1.804e-5, 1.256e-5, 0.778e-5, 0.481e-5];

% Modificar com os dados gerados do descomprime.m e da síntese lógica %
Area_IDWT  = [988.25, 883.74, 777.63, 682.91, ...
              588.18, 493.46, 396.72, 314.03];

Energia_IDWT = Power_IDWT * Freq_Hz;

% Modificar com os dados gerados do descomprime.m e da síntese lógica %
PSNR_Comp = [30.43, 30.335, 28.696, 25.39, 24.391, 19.178, 10.004, 5.4631]; 
NCC_Comp  = [0.99342, 0.99332, 0.99264, 0.99121, 0.98303, 0.94794, 0.83186, NaN];

% Modificar com os dados gerados do descomprime.m e da síntese lógica %
PSNR_Decomp = [10.985, 11.128, 11.379, 11.941, 12.666, 12.002, 10.253, 8.274];
NCC_Decomp  = [0.99534, 0.99336, 0.98069, 0.93891, 0.78789, 0.37564, 0.19659, 0.02108];

marcador_tamanho = 120;
cor_mapa = 'jet'; 

plot_custom = @(x_data, y_data, x_lbl, y_lbl, title_str, fig_name) ...
    criar_grafico(x_data, y_data, K_vec, x_lbl, y_lbl, title_str, fig_name, marcador_tamanho, cor_mapa);

plot_custom(Area_DWT,    PSNR_Comp, 'Área DWT (\mum^2)',     'Acurácia (PSNR dB)', 'Comprimida: ACC vs Área (DWT)',    'Fig1_Comp_ACC_Area');
plot_custom(Energia_DWT, PSNR_Comp, 'Energia DWT (P \times f)', 'Acurácia (PSNR dB)', 'Comprimida: ACC vs Energia (DWT)', 'Fig2_Comp_ACC_Energia');
plot_custom(Energia_DWT, NCC_Comp,  'Energia DWT (P \times f)', 'NCC (0-1)',          'Comprimida: NCC vs Energia (DWT)', 'Fig3_Comp_NCC_Energia');
plot_custom(Area_DWT,    NCC_Comp,  'Área DWT (\mum^2)',     'NCC (0-1)',          'Comprimida: NCC vs Área (DWT)',    'Fig4_Comp_NCC_Area');

plot_custom(Area_IDWT,    PSNR_Decomp, 'Área IDWT (\mum^2)',     'Acurácia (PSNR dB)', 'Descomprimida: ACC vs Área (IDWT)',    'Fig5_Decomp_ACC_Area');
plot_custom(Energia_IDWT, PSNR_Decomp, 'Energia IDWT (P \times f)', 'Acurácia (PSNR dB)', 'Descomprimida: ACC vs Energia (IDWT)', 'Fig6_Decomp_ACC_Energia');
plot_custom(Energia_IDWT, NCC_Decomp,  'Energia IDWT (P \times f)', 'NCC (0-1)',          'Descomprimida: NCC vs Energia (IDWT)', 'Fig7_Decomp_NCC_Energia');
plot_custom(Area_IDWT,    NCC_Decomp,  'Área IDWT (\mum^2)',     'NCC (0-1)',          'Descomprimida: NCC vs Área (IDWT)',    'Fig8_Decomp_NCC_Area');

disp('Gráficos gerados com sucesso (Hardware separado)!');

end

function criar_grafico(x, y, k, x_lab, y_lab, t_str, f_name, sz, cmap)
    figure('Name', f_name, 'Color', 'w', 'Position', [100 100 600 500]);
    
    scatter(x, y, sz, k, 'filled', 'MarkerEdgeColor', 'k');
    colormap(cmap);
    
    c = colorbar;
    c.Label.String = 'Nível de Truncamento (K)';
    c.Ticks = 1:8;
    
    title(t_str, 'FontSize', 12, 'FontWeight', 'bold');
    xlabel(x_lab, 'FontSize', 11);
    ylabel(y_lab, 'FontSize', 11);
    grid on;
    box on;
    
    hold on;
    [x_sort, idx] = sort(x);
    y_sort = y(idx);
    
    valid_idx = ~isnan(y_sort);
    if any(valid_idx)
        plot(x_sort(valid_idx), y_sort(valid_idx), '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1.5);
    end
    hold off;
end