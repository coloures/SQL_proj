import psycopg2
import pymysql
from config import db_host, db_name, db_password, db_user, mysql_db_host, mysql_db_user, mysql_db_password, mysql_db_name

def transfer_pg_to_mysql():
    pg_conn = psycopg2.connect(
        host=db_host,
        database = db_name,
        user = db_user,
        password = db_password
    )
    pg_cur = pg_conn.cursor()
    
    pg_cur.execute("SELECT * FROM s_psql_dds.v_dm_task")
    data = pg_cur.fetchall()
    print(f"Найдено {len(data)} строк в витрине PostgreSQL")
    
    pg_cur.close()
    pg_conn.close()

    mysql_conn = pymysql.connect(
        host = mysql_db_host,
        database = mysql_db_name,
        user = mysql_db_user,
        password = mysql_db_password
    )
    mysql_cur = mysql_conn.cursor()

    sql = """
    INSERT INTO t_dm_task_mysql 
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    """
    
    mysql_cur.executemany(sql, data)
    mysql_conn.commit()
    
    print(f"Скопировано {mysql_cur.rowcount} строк в MySQL")
    
    mysql_cur.close()
    mysql_conn.close()