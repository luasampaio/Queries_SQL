import mysql.connector
from mysql.connector import Error
import pandas as pd
import SQL_dados
from ativos import actives_dataframe

"""
PROGRAMA PARA ADICIONAR DADOS DE TABELA PARA SQL. PONTOS IMPORTANTES:
NECESSÁRIO OUTRO PROGRAMA COM NOME "SQL_dados.py" com senha hostname e username.
antes mesmo de fazer conexão neste arquivo, necessário rodar os comandos de definir banco de dados, colunas e orderstable
"""


def create_server_connection(host_name, user_name, user_password):
    connection = None
    try:
        connection = mysql.connector.connect(
            host=host_name,
            user=user_name,
            passwd=user_password
        )
        print('Connected successfully')
    except Error as err:
        print(f'Error "{err}"')
    return connection


def create_db_connection(host_name, user_name, user_password, db_name):
    connection = None
    try:
        connection = mysql.connector.connect(
            host=host_name,
            user=user_name,
            passwd=user_password,
            database=db_name
        )
        print("MySQL database connection successful")
    except Error as err:
        print(f'Error "{err}"')
    return connection


def execute_query(connection, query):
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        connection.commit()
        print('query was sucessful')
    except Error as err:
        print(f'Error {err}')


def criar_query_adicionar_dados(dataframe, lista_dados, lista_colunas):
    create_orders_table = f'INSERT INTO {dataframe} '

    colunas = '('
    for valor in lista_colunas:
        colunas += valor
        colunas += ', '
    colunas = colunas[:-2]
    colunas += ")"

    create_orders_table += colunas
    create_orders_table += ' VALUES '

    values = str()
    for valor in lista_dados:
        values += "("
        for v in valor:
            if str(v) == 'Data \nProg. Fab.':
                v = 'Data Prog. Fab.'
            values += "'"
            values += str(v)
            values += "'"
            values += ","
        values = values[:-1]
        values += "),"
    values = values[:-2]
    values += ')'

    create_orders_table += values
    create_orders_table += ';'

    return create_orders_table


def query_criar_database(dataframe, nome_database, lista_colunas):
    create_query_criar_colunas = f'CREATE TABLE `{dataframe}`.`{nome_database}` ('
    create_query_criar_colunas += '`ID` INT NOT NULL AUTO_INCREMENT,'
    for coluna in lista_colunas:
        create_query_criar_colunas += f'`{coluna}` varchar(45) NULL,'

    create_query_criar_colunas += 'PRIMARY KEY (`ID`));'

    return create_query_criar_colunas


pw = SQL_dados.password
db = 'qssma'
hostname = SQL_dados.hostname
username = SQL_dados.username
nome_table = 'ativos'

banco_de_dados = pd.DataFrame


def definir_banco_de_dados(banco_de_dados_fornecido):
    global banco_de_dados
    banco_de_dados = banco_de_dados_fornecido


colunas = []


def definir_colunas():
    global colunas
    global banco_de_dados

    colunas = banco_de_dados.columns.values.tolist()

    lista_colunas = list()
    for valor in colunas:
        # tratamento erros de dados
        valor = valor.replace(' ', '_')
        valor = valor.replace('\r', '')
        valor = valor.replace('\n', '_')
        valor = valor.replace('í', 'i')
        valor = valor.replace('ç', 'c')
        valor = valor.replace('Ç', 'C')
        valor = valor.replace('Ã', 'A')
        valor = valor.replace('ã', 'a')
        valor = valor.replace('ID', 'Identificacao')
        valor = valor.replace('.', '')
        valor = valor.replace(':', '')
        lista_colunas.append(valor)
    colunas = lista_colunas[:]

# --- COMANDOS ---

# -> CRIAR COMANDOS DE QUERY

create_orders_table = []


def definir_orders_table():
    global create_orders_table
    global banco_de_dados

    # DELETAR DADOS ANTERIORES
    deletar_bd = f'DROP TABLE {nome_table};'
    create_orders_table.append(deletar_bd)

    # Criar Database
    # criar_bd = open('CRIACAO TABELA SQL.txt').read()
    # create_orders_table = criar_bd
    create_orders_table.append(query_criar_database(dataframe=db, nome_database=nome_table, lista_colunas=colunas))

    # ADICIONAR DADOS
    dados = banco_de_dados.values.tolist()
    create_orders_table.append(criar_query_adicionar_dados(nome_table, lista_dados=dados, lista_colunas=colunas))

# verificacao dos códigos
# with open('codigo criar database.txt', 'w') as d:
#     d.write(create_orders_table[1])
#
# with open('codigo.txt', 'w') as f:
#     f.write(create_orders_table[2])

# FAZER QUERYS

lista_conexao = [hostname, username, pw, db]


# connection = create_db_connection(hostname, 'root', pw, db)
# execute_query(connection, create_orders_table)

# comando para realização dos códigos \/


def executar_querys(lista_connection, lista_queryies):
    connection = create_db_connection(lista_connection[0], lista_connection[1], lista_connection[2],
                                      lista_connection[3])
    for query in lista_queryies:
        execute_query(connection, query)


# comando para importar para main \/


def executar_todas_querys():
    connection = create_db_connection(lista_conexao[0], lista_conexao[1], lista_conexao[2],
                                      lista_conexao[3])
    for query in create_orders_table:
        execute_query(connection, query)


def BD_to_SQL(bd):
    definir_banco_de_dados(bd)
    definir_colunas()
    definir_orders_table()
    create_server_connection(host_name=hostname, user_name=username, user_password=pw)
    executar_querys(lista_conexao, create_orders_table)


def read_query(connection, query):
    cursor = connection.cursor()
    result = None
    try:
        cursor.execute(query)
        result = cursor.fetchall()
        return result
    except Error as err:
        print(f'Error {err}')


if __name__ == '__main__':
    data = actives_dataframe()

    BD_to_SQL(data)



    # definir_banco_de_dados(data)
    # definir_colunas()
    # definir_orders_table()
    #
    # create_server_connection(host_name=hostname, user_name=username, user_password=pw)
    # executar_querys(lista_conexao, create_orders_table)




    # executar_querys(lista_conexao, create_orders_table)

    # # inserir e modificar dados
    # create_server_connection(host_name=hostname, user_name=username, user_password=pw)
    # executar_querys(lista_conexao, [create_orders_table[1]])





    # # ler dados do SQL
    # query_to_read_sql = f"SELECT * FROM {nome_table}"
    # connection = create_db_connection(lista_conexao[0], lista_conexao[1], lista_conexao[2],
    #                                   lista_conexao[3])
    # results = read_query(connection=connection, query=query_to_read_sql)
    # for result in results:
    #     print(result)

    # # exportar dados
    # BD_to_SQL(pd.read_csv('teste.csv'))

