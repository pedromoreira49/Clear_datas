%{
-------------------------------------------------------------------------------
TÍTULO: descomprime_trunc.m
-------------------------------------------------------------------------------
AUTOR:     Professora Doutora Morgana Macedo Azevedo da Rosa
DATA:      07/11/2025
VERSÃO:    [1.0]
VERSÃO MATLAB: R2016
-------------------------------------------------------------------------------
DESCRIÇÃO/OBJETIVO:
    Este módulo é responsável por descomprimir uma imagem utilizando wavelet haar implementada em vhdl.
-------------------------------------------------------------------------------
%}

function descomprime_trunc

%%
need = { ...
  'X', ...
  'LL1','LL2','LL3','LL4','LL5','LL6','LL7','LL8', ...
  'iLL1','iLL2','iLL3','iLL4','iLL5','iLL6','iLL7','iLL8', ...
  'iLH1','iLH2','iLH3','iLH4','iLH5','iLH6','iLH7','iLH8', ...
  'iHL1','iHL2','iHL3','iHL4','iHL5','iHL6','iHL7','iHL8', ...
  'iHH1','iHH2','iHH3','iHH4','iHH5','iHH6','iHH7','iHH8' ...
};
for ii = 1:numel(need)
    v = need{ii};
    ex = evalin('base', sprintf('exist(''%s'',''var'')', v));
    if ex ~= 1
        error('Variavel ausente no workspace: %s', v);
    end
end

%%
X   = evalin('base','X');
LL1 = evalin('base','LL1');  LL2 = evalin('base','LL2');  LL3 = evalin('base','LL3');  LL4 = evalin('base','LL4');
LL5 = evalin('base','LL5');  LL6 = evalin('base','LL6');  LL7 = evalin('base','LL7');  LL8 = evalin('base','LL8');

iLL1 = evalin('base','iLL1'); iLL2 = evalin('base','iLL2'); iLL3 = evalin('base','iLL3'); iLL4 = evalin('base','iLL4');
iLL5 = evalin('base','iLL5'); iLL6 = evalin('base','iLL6'); iLL7 = evalin('base','iLL7'); iLL8 = evalin('base','iLL8');

iLH1 = evalin('base','iLH1'); iLH2 = evalin('base','iLH2'); iLH3 = evalin('base','iLH3'); iLH4 = evalin('base','iLH4');
iLH5 = evalin('base','iLH5'); iLH6 = evalin('base','iLH6'); iLH7 = evalin('base','iLH7'); iLH8 = evalin('base','iLH8');

iHL1 = evalin('base','iHL1'); iHL2 = evalin('base','iHL2'); iHL3 = evalin('base','iHL3'); iHL4 = evalin('base','iHL4');
iHL5 = evalin('base','iHL5'); iHL6 = evalin('base','iHL6'); iHL7 = evalin('base','iHL7'); iHL8 = evalin('base','iHL8');

iHH1 = evalin('base','iHH1'); iHH2 = evalin('base','iHH2'); iHH3 = evalin('base','iHH3'); iHH4 = evalin('base','iHH4');
iHH5 = evalin('base','iHH5'); iHH6 = evalin('base','iHH6'); iHH7 = evalin('base','iHH7'); iHH8 = evalin('base','iHH8');

%%
MODE = 'auto';         % 'auto', 'interleave', 'concat' ou 'perflow_full'
P = 128*128;           % 128x128

% --------- montar celulas ---------
LL_cells  = {LL1, LL2, LL3, LL4, LL5, LL6, LL7, LL8};
iLL_cells = {iLL1,iLL2,iLL3,iLL4,iLL5,iLL6,iLL7,iLL8};
iLH_cells = {iLH1,iLH2,iLH3,iLH4,iLH5,iLH6,iLH7,iLH8};
iHL_cells = {iHL1,iHL2,iHL3,iHL4,iHL5,iHL6,iHL7,iHL8};
iHH_cells = {iHH1,iHH2,iHH3,iHH4,iHH5,iHH6,iHH7,iHH8};

to01 = @(img) mat2gray(double(img));

%%
Xu8        = uint8(X);
Xref_half  = imresize(Xu8(:,1:256), 0.5);
A_comp_ref   = to01(Xref_half);
A_decomp_ref = to01(Xu8);

%%
[LL_all, mode_used_LL] = merge8_auto(LL_cells, P, MODE);
comprimida = reshape(double(LL_all), [128 128]);
comprimida = imrotate(comprimida, 90);
comprimida = flip(comprimida);

[iLL_all, mode_used_iLL] = merge8_auto(iLL_cells, P, MODE);
[iLH_all, mode_used_iLH] = merge8_auto(iLH_cells, P, MODE);
[iHL_all, mode_used_iHL] = merge8_auto(iHL_cells, P, MODE);
[iHH_all, mode_used_iHH] = merge8_auto(iHH_cells, P, MODE);

descomprimida = zeros(256,256);
l = 1;
for i = 1:128
    for j = 1:128
        descomprimida(2*i-1, 2*j-1) = iLL_all(l);
        descomprimida(2*i-1, 2*j  ) = iLH_all(l);
        descomprimida(2*i  , 2*j-1) = iHL_all(l);
        descomprimida(2*i  , 2*j  ) = iHH_all(l);
        l = l + 1;
    end
end

fprintf('Modo detectado LL:   %s\n', mode_used_LL);
fprintf('Modo detectado iLL:  %s\n', mode_used_iLL);
fprintf('Modo detectado iLH:  %s\n', mode_used_iLH);
fprintf('Modo detectado iHL:  %s\n', mode_used_iHL);
fprintf('Modo detectado iHH:  %s\n', mode_used_iHH);

%%
figure('Name','Original vs Comprimida vs Descomprimida');
subplot(1,3,1); imshow(Xu8);                   title('Original 256x256');
subplot(1,3,2); imshow(uint8(comprimida));     title('Comprimida 128x128');
subplot(1,3,3); imshow(uint8(descomprimida));  title('Descomprimida 256x256');

%%
B_comp   = to01(comprimida);
B_decomp = to01(descomprimida);

nc_comp   = corr2(A_comp_ref,   B_comp);
mse_comp  = immse(B_comp,       A_comp_ref);
mae_comp  = mean(abs(B_comp(:)  - A_comp_ref(:)));
psnr_comp = psnr(B_comp,        A_comp_ref);

nc_decomp   = corr2(A_decomp_ref, B_decomp);
mse_decomp  = immse(B_decomp,     A_decomp_ref);
mae_decomp  = mean(abs(B_decomp(:)- A_decomp_ref(:)));
psnr_decomp = psnr(B_decomp,      A_decomp_ref);

fprintf('\n=== Metricas Globais ===\n');
fprintf('Comprimida vs ref(128x128)\n');
fprintf('  NC   : %.6f\n  MSE  : %.6f\n  MAE  : %.6f\n  PSNR : %.6f dB\n', ...
    nc_comp, mse_comp, mae_comp, psnr_comp);
fprintf('\nDescomprimida vs original(256x256)\n');
fprintf('  NC   : %.6f\n  MSE  : %.6f\n  MAE  : %.6f\n  PSNR : %.6f dB\n', ...
    nc_decomp, mse_decomp, mae_decomp, psnr_decomp);
fprintf('=========================\n');

Metric = {'NC'; 'MSE'; 'MAE'; 'PSNR_dB'};
Comprimida    = [nc_comp; mse_comp; mae_comp; psnr_comp];
Descomprimida = [nc_decomp; mse_decomp; mae_decomp; psnr_decomp];
Tglobal = table(Metric, Comprimida, Descomprimida);
disp(Tglobal);

%%
nc_comp_K     = zeros(8,1);
mse_comp_K    = zeros(8,1);
mae_comp_K    = zeros(8,1);
psnr_comp_K   = zeros(8,1);

nc_decomp_K     = zeros(8,1);
mse_decomp_K    = zeros(8,1);
mae_decomp_K    = zeros(8,1);
psnr_decomp_K   = zeros(8,1);

figure('Name','Comprimida por K 128x128');
for K = 1:8
    [LL_k, ~] = merge_only_k_auto(LL_cells, P, MODE, K);
    compK = reshape(double(LL_k), [128 128]);
    compK = imrotate(compK, 90);
    compK = flip(compK);
    B_compK = to01(compK);

    nc_comp_K(K)   = corr2(A_comp_ref, B_compK);
    mse_comp_K(K)  = immse(B_compK, A_comp_ref);
    mae_comp_K(K)  = mean(abs(B_compK(:) - A_comp_ref(:)));
    psnr_comp_K(K) = psnr(B_compK,  A_comp_ref);

    subplot(2,4,K);
    imshow(uint8(255*B_compK));
    title(sprintf('K=%d comp NC=%.3f', K, nc_comp_K(K)));
end

figure('Name','Descomprimida por K 256x256');
for K = 1:8
    [iLL_k, ~] = merge_only_k_auto(iLL_cells, P, MODE, K);
    [iLH_k, ~] = merge_only_k_auto(iLH_cells, P, MODE, K);
    [iHL_k, ~] = merge_only_k_auto(iHL_cells, P, MODE, K);
    [iHH_k, ~] = merge_only_k_auto(iHH_cells, P, MODE, K);

    decompK = zeros(256,256);
    l = 1;
    for i = 1:128
        for j = 1:128
            decompK(2*i-1, 2*j-1) = iLL_k(l);
            decompK(2*i-1, 2*j  ) = iLH_k(l);
            decompK(2*i  , 2*j-1) = iHL_k(l);
            decompK(2*i  , 2*j  ) = iHH_k(l);
            l = l + 1;
        end
    end
    B_decompK = to01(decompK);

    nc_decomp_K(K)   = corr2(A_decomp_ref, B_decompK);
    mse_decomp_K(K)  = immse(B_decompK, A_decomp_ref);
    mae_decomp_K(K)  = mean(abs(B_decompK(:) - A_decomp_ref(:)));
    psnr_decomp_K(K) = psnr(B_decompK,  A_decomp_ref);

    subplot(2,4,K);
    imshow(uint8(255*B_decompK));
    title(sprintf('K=%d decomp NC=%.3f', K, nc_decomp_K(K)));
end

%%
fprintf('\n=== Metricas por K - Comprimida (ref 128x128) ===\n');
fprintf('K  |      NC      |       MSE       |      MAE       |  PSNR (dB)\n');
fprintf('---+--------------+-----------------+----------------+-----------\n');
for K = 1:8
    fprintf('%-2d | % .6f | % .9f | % .9f | % .6f\n', ...
        K, nc_comp_K(K), mse_comp_K(K), mae_comp_K(K), psnr_comp_K(K));
end

fprintf('\n=== Metricas por K - Descomprimida (ref 256x256) ===\n');
fprintf('K  |      NC      |       MSE       |      MAE       |  PSNR (dB)\n');
fprintf('---+--------------+-----------------+----------------+-----------\n');
for K = 1:8
    fprintf('%-2d | % .6f | % .9f | % .9f | % .6f\n', ...
        K, nc_decomp_K(K), mse_decomp_K(K), mae_decomp_K(K), psnr_decomp_K(K));
end

%%
T_compK = table((1:8).', nc_comp_K, mse_comp_K, mae_comp_K, psnr_comp_K, ...
    'VariableNames', {'K','NC_comp','MSE_comp','MAE_comp','PSNR_comp_dB'});
T_decompK = table((1:8).', nc_decomp_K, mse_decomp_K, mae_decomp_K, psnr_decomp_K, ...
    'VariableNames', {'K','NC_decomp','MSE_decomp','MAE_decomp','PSNR_decomp_dB'});
disp('--- Comprimida por K (todas as metricas) ---');  disp(T_compK);
disp('--- Descomprimida por K (todas as metricas) ---'); disp(T_decompK);

%%
figure('Name','K vs Acuracia NC Descomprimida');
plot(1:8, nc_decomp_K, 'o-','LineWidth',1.5,'MarkerSize',6);
xlim([1 8]); set(gca,'XTick',1:8);
xlabel('K'); ylabel('Acuracia (NC)');
title('Acuracia por Fluxo (NC descomprimida)');
grid on;

figure('Name','K vs Acuracia PSNR Comprimida');
plot(1:8, mae_comp_K, 'o-','LineWidth',1.5,'MarkerSize',6);
xlim([1 8]); set(gca,'XTick',1:8);
xlabel('K'); ylabel('MAE');
title('MAE Comprimida');
grid on;

% Pedro Moreira: Código para gerar arquivos .csv %
writetable(Tglobal, 'metricas_globais.csv');
writetable(T_compK, 'metricas_compressao.csv');
writetable(T_decompK, 'metricas_descompressao.csv');
disp('CSV SALVO.');
%End Pedro Moreira %
end 

%%
function [v,mode_used] = merge8_auto(cells, P, MODE)
    n = zeros(1,8);
    for k = 1:8, n(k) = numel(cells{k}); end
    total = sum(n);

    wanted_each = P/8; 
    is_interleave = all(n == wanted_each);
    is_concat     = (total == P);
    is_full_each  = all(n == P);

    if strcmpi(MODE,'auto')
        if is_interleave
            MODE_eff = 'interleave';
        elseif is_concat
            MODE_eff = 'concat';
        elseif is_full_each
            MODE_eff = 'perflow_full';
        else
            error(['Nao foi possivel detectar o mapeamento automaticamente. ', ...
                   'Tamanhos: [%s], P=%d.'], num2str(n), P);
        end
    else
        MODE_eff = lower(MODE);
        if strcmp(MODE_eff,'interleave') && ~is_interleave
            error('INTERLEAVE esperado %d por fluxo, recebidos: [%s].', wanted_each, num2str(n));
        end
        if strcmp(MODE_eff,'concat') && ~is_concat
            error('CONCAT esperado soma = %d, soma recebida = %d.', P, total);
        end
        if strcmp(MODE_eff,'perflow_full') && ~is_full_each
            error('PERFLOW_FULL esperado %d por fluxo, recebidos: [%s].', P, num2str(n));
        end
    end

    v = zeros(P,1);
    switch MODE_eff
        case 'interleave'
            for k = 1:8
                idx = k:8:P;
                vk  = cells{k};
                v(idx) = vk(:);
            end
        case 'concat'
            base = 0;
            for k = 1:8
                vk = cells{k}(:);
                nk = numel(vk);
                v(base+(1:nk)) = vk;
                base = base + nk;
            end
        case 'perflow_full'
            acc = zeros(P,1);
            for k = 1:8
                acc = acc + cells{k}(:);
            end
            v = acc / 8.0;
        otherwise
            error('MODE interno invalido.');
    end

    mode_used = MODE_eff;
end

function [vK,mode_used] = merge_only_k_auto(cells, P, MODE, K)

    n = zeros(1,8);
    for kk = 1:8, n(kk) = numel(cells{kk}); end
    total = sum(n);

    wanted_each = P/8;
    is_interleave = all(n == wanted_each);
    is_concat     = (total == P);
    is_full_each  = all(n == P);

    if strcmpi(MODE,'auto')
        if is_interleave
            MODE_eff = 'interleave';
        elseif is_concat
            MODE_eff = 'concat';
        elseif is_full_each
            MODE_eff = 'perflow_full';
        else
            error(['Nao foi possivel detectar o mapeamento automaticamente (K). ', ...
                   'Tamanhos: [%s], P=%d.'], num2str(n), P);
        end
    else
        MODE_eff = lower(MODE);
    end

    vK = zeros(P,1);
    switch MODE_eff
        case 'interleave'
            idx = K:8:P;
            vk  = cells{K}(:);
            if numel(vk) ~= numel(idx)
                error('Fluxo %d tamanho invalido p/ interleave. Recebido %d, esperado %d.', ...
                      K, numel(vk), numel(idx));
            end
            vK(idx) = vk;
        case 'concat'
            base = 0;
            for k = 1:K-1
                base = base + numel(cells{k});
            end
            nk = numel(cells{K});
            vK(base+(1:nk)) = cells{K}(:);
        case 'perflow_full'
            vK = cells{K}(:);
        otherwise
            error('MODE interno invalido (K).');
    end

    mode_used = MODE_eff;
end