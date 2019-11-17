import sys
script, encoding, error = sys.argv

#define function "main"
def main(language_file, encoding, errors):
    #read line by line
    line = language_file.readline()
    
    #if loot-means if any symbols in line- do something
    if line:
        print_line(line, encoding, errors)
        #function "main" in function "main"
        return main(language_file, encoding, errors)


def print_line(line, encoding, errors):
    next_lang = line.strip()
    raw_bytes = next_lang.encode(encoding, errors=errors)
    cooked_string = raw_bytes.decode(encoding, errors=errors)

    print(raw_bytes, "<===>", cooked_string)


languages = open("languages.txt", encoding="utf-8")

main(languages, encoding, error)