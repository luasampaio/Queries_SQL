import pandas as pd
from functions.connection_sql import *
from functions.data_treatment import *
import openpyxl


def extract_employees(connection):
    query = f"select RA_MAT, RA_NOMECMP, RA_CIC, REPLACE(SUBSTRING(RA_CC, 1, 3), 'A', '0') as Centro_Custo, RA_ADMISSA, RA_DEMISSA, RA_CODFUNC, RA_NASC from [SRA010] WHERE D_E_L_E_T_ <> '*' AND RA_DEMISSA = '' ORDER BY RA_MAT"
    df_emp = pd.read_sql(query, connection)
    return df_emp


def extract_functions(connection):
    query = f"select RJ_FUNCAO, RJ_DESC from [SRJ010] WHERE D_E_L_E_T_ <> '*'"
    df_func = pd.read_sql(query, connection)
    return df_func


def full_actives(connection_db):
    employees_db = extract_employees(connection_db)

    functions_db = extract_functions(connection_db)

    functions_db = functions_db.rename(columns={'RJ_FUNCAO': 'RA_CODFUNC'})

    dataframe = pd.merge(employees_db, functions_db, on='RA_CODFUNC', how='left')

    dataframe = dataframe.drop(columns=['RA_CODFUNC'])

    dataframe['RA_ADMISSA'] = change_date_format(dataframe['RA_ADMISSA'])

    dataframe['RA_DEMISSA'] = date_format_with_null_values(dataframe['RA_DEMISSA'])

    dataframe['RA_MAT'] = pd.to_numeric(dataframe['RA_MAT'])

    dataframe['RJ_DESC'] = dataframe['RJ_DESC'].apply(lambda x: x.rstrip())

    dataframe.columns = ['Matricula', 'Nome', 'CPF', 'Centro_Custo', 'Data Admis.', 'Dt. Demissao', 'Data_Nasc', 'Função']

    dataframe['Nome'] = dataframe['Nome'].apply(lambda x: x.rstrip())

    return dataframe


def actives_dataframe():
    connection = create_conection()

    DF = full_actives(connection)

    # DF.to_excel('ativos.xlsx', index=False)

    return DF


if __name__ == '__main__':
    ativos = actives_dataframe()
    ativos.to_excel('ativos_teste.xlsx')
