import re
import pandas as pd

power_file = "DHWT_IDHWT_TRUNC_10000_power.rep"

dados_power = []

power_regex = re.compile(r"^\s*\d+\s+[\d\.]+\%\s+[\d\.eE\-\+]+\s+[\d\.eE\-\+]+\s+[\d\.eE\-\+]+\s+([\d\.eE\-\+]+)\s+1\s+.*?(DWT_k\d+|IDWT_k\d+)\s*$")

try:
    with open(power_file, 'r') as f:
        for line in f:
            match = power_regex.search(line)
            if match:
                total_power = float(match.group(1))
                instance = match.group(2)
                
            
                dados_power.append({
                    "Instance": instance,
                    "Total Power": total_power
                })
                

    if dados_power:
        df = pd.DataFrame(dados_power)
        
        df['k_num'] = df['Instance'].str.extract(r'(\d+)').astype(int)
        df = df.sort_values(by='k_num')
        
        df_dwt = df[df['Instance'].str.startswith('DWT')].copy()
        df_dwt = df_dwt[['Instance', 'Total Power']]
        df_dwt.to_csv("power_DWT.csv", index=False, sep=';')
        print(f"Criado 'power_DWT.csv' com {len(df_dwt)} linhas.")
        
        df_idwt = df[df['Instance'].str.startswith('IDWT')].copy()
        df_idwt = df_idwt[['Instance', 'Total Power']]
        df_idwt.to_csv("power_IDWT.csv", index=False, sep=';')
        print(f"Criado 'power_IDWT.csv' com {len(df_idwt)} linhas.")
        
    else:
        print("Nenhuma informação encontrada. Verifique o regex ou o arquivo.")

except FileNotFoundError:
    print(f"Erro: O arquivo '{power_file}' não foi encontrado.")