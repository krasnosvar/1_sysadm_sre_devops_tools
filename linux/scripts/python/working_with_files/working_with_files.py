#конструкция with ... as, как правило, является более удобной и гарантирует закрытие файла в любом случае
with open('newfile.txt', 'w', encoding='utf-8') as g:
    d = int(input())
    print('1 / {} = {}'.format(d, 1 / d), file=g)

#Пример конструкции with as, создать список из файла
ip_list_fromfile = []
with open('list_servers.txt', 'r') as dd: # открыть файл для чтения
    for servers_lines in dd.read().splitlines(): #перечитать построчно, застрипать переводы строк
        ip_list_fromfile.append(servers_lines) #add element to list created before
#print(ip_list_fromfile) #print renewed list
