# California-numbers
California numbers

It imports the necessary libraries: spacy, sklearn and pt_core_news_sm.

It opens a file called “original_text.txt” that contains the text to summarize and saves it in a variable called text.

It uses spacy to split the text into sentences and saves them in a list called corpus.

It uses CountVectorizer from sklearn to create a word frequency matrix, ignoring the stop words.

It creates a dictionary called word_frequency that associates each word with its relative frequency in the text.

It sorts the dictionary by value and gets the three words with the highest frequency.

It prints the words with the highest frequency.
