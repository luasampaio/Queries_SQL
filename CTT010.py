import pandas as pd
from functions.connection_sql import *
from functions.data_treatment import *
import openpyxl
from commands_sql import create_db_connection, hostname, username, pw
from ativos import actives_dataframe


def extract_CC_data(connection):
    query = f"select CONCAT('0', SUBSTRING(CTT_CUSTO, 2, 2)) AS Centro_Custo, CONCAT(CONCAT('0', SUBSTRING(CTT_CUSTO, 2, 2)), ' - ', CTT_DESC01) AS Obra from CTT010 WHERE D_E_L_E_T_ <> '*' AND SUBSTRING(CTT_CUSTO, 4, 6) = '000000' ORDER BY CTT_CUSTO;"
    df_emp = pd.read_sql(query, connection)
    return df_emp


def transorm_CC(dataframe):
    connection = create_conection()
    CC_DF = extract_CC_data(connection)
    DF = pd.merge(dataframe, CC_DF, on='Centro_Custo', how='left')
    return DF


if __name__ == '__main__':
    df = actives_dataframe()

    data = transorm_CC(df)

    df.to_excel('ativos2.xlsx')
