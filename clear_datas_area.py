import re
import pandas as pd

area_file = "DHWT_IDHWT_TRUNC_10000_area.rep"

dados_area = []

area_regex = re.compile(r"^\s*(DWT_k\d+|IDWT_k\d+)\s+\S+\s+\d+\s+[\d\.]+\s+[\d\.]+\s+([\d\.]+)")

try:
    with open(area_file, 'r') as f:
        for line in f:
            match = area_regex.search(line)
            if match:
                instance = match.group(1)
                total_area = float(match.group(2))
                
                dados_area.append({
                    "Instance": instance,
                    "Total Area": total_area
                })
                
    if dados_area:
        df = pd.DataFrame(dados_area)
        
        df['k_num'] = df['Instance'].str.extract(r'(\d+)').astype(int)
        df = df.sort_values(by='k_num')
        
        df_dwt = df[df['Instance'].str.startswith('DWT')].copy()
        df_dwt = df_dwt[['Instance', 'Total Area']]
        df_dwt.to_csv("area_DWT.csv", index=False, sep=';')
        print(f"Criado 'area_DWT.csv' com {len(df_dwt)} linhas.")
        
        df_idwt = df[df['Instance'].str.startswith('IDWT')].copy()
        df_idwt = df_idwt[['Instance', 'Total Area']]
        df_idwt.to_csv("area_IDWT.csv", index=False, sep=';')
        print(f"Criado 'area_IDWT.csv' com {len(df_idwt)} linhas.")
        
    else:
        print("Nenhuma informação encontrada. Verifique o regex ou o arquivo.")

except FileNotFoundError:
    print(f"Erro: O arquivo '{area_file}' não foi encontrado.")