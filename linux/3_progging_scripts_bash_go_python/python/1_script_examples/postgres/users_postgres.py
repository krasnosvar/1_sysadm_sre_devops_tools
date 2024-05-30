# creates users in postgres 
# python3 users_postgres.py USER
# for psycopg2 needs pg_config - is in postgresql-devel (libpq-dev in Debian/Ubuntu, libpq-devel on Centos/Fedora/Cygwin/Babun.)
# sudo apt install libpq-dev -y
# pip install psycopg2

import psycopg2
from psycopg2 import sql
#for pass generation
import string
import random
#for args
import sys


#passgen func
# https://stackoverflow.com/questions/77553485/using-python-to-create-a-random-password-generator
def generate_password(length=20):
    characters = string.ascii_letters + string.digits # + string.punctuation
    password = ''.join(random.choice(characters) for _ in range(length))
    return password
# Generate and print a random password
generated_password = generate_password()
print("Generated Password:", generated_password)


conn = psycopg2.connect(user = "postgres", 
                        host= 'localhost',
                        password = "password",
                        port = 5432)


def prompt_username(conn):
    cur = conn.cursor()
    # while True:
    username = sys.argv[1]
    cur.execute("SELECT COUNT(*) FROM pg_catalog.pg_roles WHERE rolname = %s", [username])
    n, = cur.fetchone()
    if n == 0:
        return username
    print("User already exists.")


def userCreation():
    username = prompt_username(conn)
    password = generated_password
    query = sql.SQL("CREATE ROLE {0} LOGIN PASSWORD {1} \
                     NOCREATEDB NOCREATEROLE NOSUPERUSER NOINHERIT NOREPLICATION NOBYPASSRLS").format(
        sql.Identifier(username),
        sql.Literal(password),
    )
    cur = conn.cursor()
    cur.execute(query.as_string(conn))
    cur.execute("COMMIT")
    #send to PrivateBin
if __name__ == '__main__':
    userCreation()


print(conn.cursor().execute("SELECT * FROM pg_authid WHERE rolname='den7'"))
