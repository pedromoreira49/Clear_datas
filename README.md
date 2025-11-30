# Clear Datas: Approximate Computing on Haar Wavelet Transform

Este repositório contém a implementação e análise de **Computação Aproximada** aplicada à compressão de imagens utilizando a **Transformada Discreta de Wavelet Haar (DWT)**.

O projeto explora técnicas de **Truncamento de LSBs (Least Significant Bits)** no hardware para reduzir o consumo de potência e área, avaliando o impacto resultante na qualidade da imagem reconstruída.

---

## 📋 Visão Geral do Projeto

O objetivo principal é encontrar o **Ponto Ótimo de Operação** (Sweet Spot) onde a economia de hardware (Energia/Área) é maximizada com a mínima degradação visual da imagem.

### Principais Características
* **Hardware (VHDL):** Implementação de somadores aproximados com truncamento configurável ($K$ bits).
* **Pipeline Paralelo:** Instanciação simultânea de 8 níveis de agressividade de aproximação ($K=1$ a $K=8$).
* **Análise de Qualidade (MATLAB):** Cálculo de métricas visuais (PSNR, NCC, MSE, MAE).
* **Análise de Hardware:** Extração de dados de Potência, Área e Timing via síntese lógica (Genus/Quartus).

---

## 🔄 Fluxo de Trabalho (Workflow)

Este estudo segue um fluxo cruzado entre Hardware e Software para gerar as curvas de trade-off.

### Passo 1: Design de Hardware (VHDL)
Desenvolvimento do circuito aproximados na
**Entidade Principal:** `DHWT_IDHWT_TRUNC.vhd`
* **Mecanismo:** O módulo `Somador_Nbits` possui um genérico `K`. Se $K=1$, apenas o LSB é truncado (alta precisão, alto custo). Se $K=8$, 8 bits são zerados (baixa precisão, baixo custo).
* **Top Level:** O sistema instancia 8 versões do par DWT+IDWT para processar dados em paralelo e gerar estatísticas para todos os níveis de truncamento de uma vez.

### Passo 2: Síntese Lógica & Extração de Métricas
O código VHDL é submetido a uma ferramenta de síntese (neste estudo, utilizamos Genus com tecnologia 65nm).
* **Entrada:** Arquivos VHDL.
* **Saída:** Relatórios de Área (`.rep`), Potência (`.rep`) e Timing (`.rep`).
* **Dados Extraídos:**
    * Potência Dinâmica e Estática (Watts).
    * Área Total ($\mu m^2$ ou número de células).
    * Frequência Máxima de Operação (baseada no Critical Path).

### Passo 3: Processamento de Imagem (MATLAB)
Utilizamos o MATLAB para simular o comportamento funcional do truncamento nas imagens e calcular a qualidade visual.
* **Script:** `descomprime_trunc.m`
* **Processo:**
    1.  Lê a imagem original.
    2.  Simula o truncamento dos coeficientes Wavelet (imitando o hardware).
    3.  Reconstrói a imagem (IDWT).
    4.  Compara a imagem processada com a original.
* **Métricas Geradas:** PSNR (dB), NCC (Correlação), MSE e MAE.

### Passo 4: Análise de Trade-off (Gráficos)
O passo final cruza os dados do **Passo 2** (Custo) com os dados do **Passo 3** (Qualidade).
* **Script:** `full_metrics.m`
* **Resultado:** Gera gráficos de dispersão (Scatter Plots) que mostram a relação Custo x Benefício, permitindo identificar qual configuração $K$ oferece a melhor eficiência energética.
