from commands_sql import BD_to_SQL
from ativos import actives_dataframe
from CTT010 import transorm_CC

if __name__ == '__main__':
    data = actives_dataframe()

    data = transorm_CC(data)

    BD_to_SQL(data)
