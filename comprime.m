%{
-------------------------------------------------------------------------------
TÍTULO: comprime_trunc.m
-------------------------------------------------------------------------------
AUTOR:     Professora Doutora Morgana Macedo Azevedo da Rosa
DATA:      07/11/2025
VERSÃO:    [1.0]
VERSÃO MATLAB: R2016
-------------------------------------------------------------------------------
DESCRIÇÃO/OBJETIVO:
    Este módulo é responsável por comprimir uma imagem.
-------------------------------------------------------------------------------
%}

% i300 = imagem_concatenada(:, :, 1);
% X=i300;

clc; clear;

load woman;
k=1;
for i=1:128
         for j=1:128
            X1(1,k)=X((2*i-1),(2*j-1));
            X2(1,k)=X((2*i-1),(2*j));
            X3(1,k)=X((2*i),(2*j-1));
            X4(1,k)=X((2*i),(2*j));
            k=k+1;
         end
end