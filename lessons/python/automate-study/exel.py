import openpyxl
import os
os.chdir('/media/den/240Gb/study/python/Automate_the_Boring_Stuff_onlinematerials/automate_online-materials')
wb = openpyxl.load_workbook('example.xlsx')
print(wb.get_sheet_names())
sheet = wb.get_sheet_by_name('den2')
print(sheet['A1'].value)
#print(sheet["A2"].value)
