#!/usr/bin/env python3
#in doc-file must be {{SCCN}} in double-quotes
import sys
import time
from docxtpl import DocxTemplate
#timestr = time.strftime("%Y%m%d-%H%M%S")
doc = DocxTemplate("req.docx")
path = sys.argv[4]
context = { 'SCCN' : sys.argv[1], 'SCDEPART' : sys.argv[2], 'SCSAN' : sys.argv[3]}
print((sys.argv[1::] ))
print(context)
doc.render(context)
#doc.save(f"/usr/git/work/python/cert-parse/{timestr}.docx")
doc.save(sys.argv[4])
