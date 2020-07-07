#Delete Files Using Extended Pattern Matching Operators
#The different extended pattern matching operators are listed below, where pattern-list is a list containing one or more filenames, separated using the | character:
#
#*(pattern-list) – matches zero or more occurrences of the specified patterns
#?(pattern-list) – matches zero or one occurrence of the specified patterns
#+(pattern-list) – matches one or more occurrences of the specified patterns
#@(pattern-list) – matches one of the specified patterns
#!(pattern-list) – matches anything except one of the given patterns
#To use them, enable the extglob shell option as follows:
shopt -s extglob


#delete all files except filename
rm -v !("filename")
# To delete all files with the exception of filename1 and filename2
rm -v !("filename1"|"filename2") 
#The example below shows how to remove all files other than all .zip files interactively:
rm -i !(*.zip)

#Once you have all the required commands, turn off the extglob shell option like so
shopt -u extglob
