%{
-------------------------------------------------------------------------------
TÍTULO: metrics_trade_off.m
-------------------------------------------------------------------------------
AUTOR:     Pedro Moreira
DATA:      30/11/2025
VERSÃO:    [1.0]
VERSÃO MATLAB: R2016
-------------------------------------------------------------------------------
DESCRIÇÃO/OBJETIVO:
    Este módulo é responsável por gerar a plotagem da métrica de trade off.
-------------------------------------------------------------------------------
%}

function plot_tradeoff_correto

K_vec = 1:8;

% Modificar com os dados gerados do descomprime.m e da síntese lógica %
PSNR_dB = [10.985 11.128 11.379 11.941 12.666 12.002 10.253 8.274];

Power_W = [4.03599e-05 3.57779e-05 3.033e-05 2.41898e-05 ...
           1.80392e-05 1.25624e-05 7.77655e-06 4.8134e-06];

Power_uW = Power_W * 1e6;

[max_psnr, idx_best] = max(PSNR_dB);
best_K = K_vec(idx_best);
best_P = Power_uW(idx_best);

figure('Name', 'Trade-off: Computação Aproximada', 'Color', 'w', 'Position', [100 100 800 600]);

scatter(Power_uW, PSNR_dB, 150, K_vec, 'filled', 'MarkerEdgeColor', 'k');

colormap(jet); 
c = colorbar;
c.Label.String = 'Nível de Truncamento (Bits K)';
c.Ticks = 1:8;

grid on;
xlabel('Potência Consumida (\muW)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Qualidade de Reconstrução (PSNR dB)', 'FontSize', 12, 'FontWeight', 'bold');
title({'Espaço de Design: Qualidade vs. Potência', ...
       'Somador Wavelet Aproximado (Truncamento)'}, 'FontSize', 14);

xlim([0 max(Power_uW)*1.1]);
ylim([min(PSNR_dB)*0.9 max(PSNR_dB)*1.1]);

hold on;

plot(Power_uW, PSNR_dB, '--', 'Color', [0.6 0.6 0.6], 'LineWidth', 1);

plot(best_P, max_psnr, 'p', 'MarkerSize', 20, 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'k');
text(best_P, max_psnr + 0.8, sprintf(' Melhor Caso (K=%d)\n %.2f dB @ %.1f \\muW', best_K, max_psnr, best_P), ...
    'HorizontalAlignment', 'center', 'FontWeight', 'bold', 'BackgroundColor', 'w', 'EdgeColor', 'g');

text(Power_uW(1), PSNR_dB(1) - 0.5, ' K=1 (Quase Exato)', ...
    'HorizontalAlignment', 'left', 'FontSize', 9);

text(Power_uW(end), PSNR_dB(end) - 0.5, ' K=8 (Muito Aprox.)', ...
    'HorizontalAlignment', 'right', 'FontSize', 9);

Eficiencia = PSNR_dB ./ Power_uW;

axes('Position',[.65 .2 .25 .25]);
bar(K_vec, Eficiencia, 'FaceColor', [0.2 0.6 0.8]);
title('Eficiência (dB / \muW)');
xlabel('K'); grid on;
box on;

end