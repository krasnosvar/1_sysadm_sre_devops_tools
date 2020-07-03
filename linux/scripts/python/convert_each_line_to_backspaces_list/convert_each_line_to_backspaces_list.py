#https://stackoverflow.com/questions/3925614/how-do-you-read-a-file-into-a-list-in-python
#https://stackoverflow.com/questions/42500944/how-to-change-the-list-separator-in-python
with open('list.txt') as f:
    lines = f.read().replace('\n',' ')
    #lines = f.read().replace(', ','\n')
    print(lines)
