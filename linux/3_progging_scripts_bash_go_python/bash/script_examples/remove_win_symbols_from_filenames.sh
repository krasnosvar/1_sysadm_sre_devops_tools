#execute in folder with win_synbols files, dirs
for f in *; do mv "$f" `echo $f | tr ' ' '_'`; done
for f in *; do mv "$f" `echo $f | tr '(' '_'`; done
for f in *; do mv "$f" `echo $f | tr ')' '_'`; done
for f in *; do mv "$f" `echo $f | tr ',' '_'`; done
for f in *; do mv "$f" $(echo $f | tr ',' '_'); done
