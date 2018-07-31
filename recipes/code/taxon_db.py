import sqlite3
import os, sys
import csv
from itertools import *

#set tmp directory for sqlite3
os.environ["SQLITE_TMPDIR"]="/home/aswathy/tmp"

CHUNK = 100000
LIMIT = 100000
LIMIT = None


def get_conn(dbname):
    conn = sqlite3.connect(dbname)
    return conn


# A function which creates database (even if database is present,
def create_db(dbname):
    if os.path.isfile(dbname):
        os.remove(dbname)
    conn = get_conn(dbname)
    curs = conn.cursor()

    # create acc2taxon table
    curs.execute('''CREATE TABLE acc2taxon
               (accession, lineage)''')

    # Save the table within the database (Save changes)
    conn.commit()


def create_acc2taxon(dbname, fname):
    conn = get_conn(dbname)
    curs = conn.cursor()

    stream = csv.DictReader(open(fname), delimiter='\t')
    stream = islice(stream, LIMIT)
    data = []
    for index, row in enumerate(stream):

        data.append((row['Feature ID'], row['Taxon']))

        remain = index % CHUNK

        if remain == 0 and data:
            curs.executemany('INSERT INTO acc2taxon VALUES (?,?)', data)
            conn.commit()
            print("commit")
            print(index)

            data = []
            # print (row['GeneID'])
    print("Table creation Done")

    sql_commands = [
        'CREATE INDEX acc2taxon_accession ON acc2taxon(accession)',

    ]
    for sql in sql_commands:
        curs.execute(sql)

    print("Indexing done")


if __name__ == '__main__':
    #dbname = 'taxon_db'
    dbname = sys.argv[1]
    inputfile = sys.argv[2]
    create_db(dbname)
    #print_db(dbname)
    create_acc2taxon(dbname, inputfile)
