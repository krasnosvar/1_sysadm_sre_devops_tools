import sys
import urllib2, ssl

download = sys.argv[1]
fileguid = download.split('/')[-1] if '/' in download else download

filedata = urllib2.urlopen('https://fileobmen.corp.domain.ru/download.php?fcode=' + fileguid, context=ssl._create_unverified_context())
filename = filedata.headers.dict['content-disposition'].split('=')[1]
datatowrite = filedata.read()

with open(filename, 'wb') as f:
    f.write(datatowrite)
