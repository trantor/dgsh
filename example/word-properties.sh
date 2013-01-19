#!/usr/local/bin/sgsh
#
# Obtain a text document from the specified URL and list words
# containing a two-letter palindrome, words containing
# four consonants, and words longer than 12 characters.
#
# Demonstrates the use of paste as a gather function
#
# Example:
# word-properties ftp://sunsite.informatik.rwth-aachen.de/pub/mirror/ibiblio/gutenberg/1/3/139/139.txt
#
#  Copyright 2013 Diomidis Spinellis
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

scatter |{
	# Obtain file
	curl "$1" |
	# Split into one word per line
	tr -cs a-zA-Z \\n |
	# Create list of unique words
	sort -u |{
		# Pass through the original words
		-||>/sgsh/words

		# List two-letter palindromes
		-| sed 's/.*\(.\)\(.\)\2\1.*/p: \1\2-\2\1/;t;g' |>/sgsh/palindromes
		# List four consecutive consonants
		-| sed -E 's/.*([^aeiouyAEIOUY]{4}).*/c: \1/;t;g' |>/sgsh/consonants

		# List length of words longer than 12 characters
		-| awk '{if (length($1) > 12) print "l:", length($1); else print ""}' |>/sgsh/long
	|}
|} gather |{
	# Paste the four streams side-by-side
	paste /sgsh/words /sgsh/palindromes /sgsh/consonants /sgsh/long |
	# List only words satisfying one or more properties
	grep :
|}
