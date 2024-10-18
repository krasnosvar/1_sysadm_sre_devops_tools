import asyncio


# shell PSQL ( psql installed ) command with remote commection to postgres and execute SELECT ( with non-interactive password, and timing ON )
cmd = '''
PGPASSWORD=12345 \
psql -U root -p 5432 -h postgreas-host postgres << EOF
\\timing on
SELECT *
  FROM information_schema.role_table_grants 
 WHERE grantee = 'root';
SELECT pg_size_pretty( pg_database_size('postgres') );
EOF
'''


# https://medium.com/@kalmlake/async-io-in-python-subprocesses-af2171d1ff31
async def run_program():
    proc = await asyncio.create_subprocess_shell(
        cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE
    )
    stdout, stderr = await proc.communicate()
    print(f'Standard Output: {stdout.decode()}')
    print(f'Error: {stderr.decode()}')

# https://0xdf.gitlab.io/2022/04/24/parallelizing-in-bash-and-python.html
async def main():
        tasks = []
        for i in range(1, 11):
            tasks.append(asyncio.ensure_future(run_program()))

        await asyncio.gather(*tasks)


asyncio.run(main())
