def break_words(stuff):
    """this function breaks text string onto words."""
    words = stuff.split(" ")
    return words

def sort_words(words):
    "comment"
    return sorted(words)

def print_first_word(words):
    word=words.pop(0)
    print(word)

def print_last_word(words):
    word=words.pop(-1)
    print(word)

def sort_sentence(sentence):
    """takes whole sentence and returns sorted words"""
    words=break_words(sentence)
    return sort_words(words)

def print_first_and_last(sentence):
    words=break_words(sentence)
    print_first_word(words)
    print_last_word(words)

def print_first_and_last_sorted(sentence):
    words=sort_sentence(sentence)
    print_first_word(words)
    print_last_word(words)
