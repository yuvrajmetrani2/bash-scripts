-------------------------------
sed A.K.A - stream editor
-------------------------------

Functionalities/features, high level 

1. s - SubstitutingText
2. d - Deleting Text
3. i - Inserting new line of text before specified line
4. a - Appending new line of text after the specified line
5. y - Transforming specific single characters by one-to-one character mapping
6. p - Print a line of text that matches a filter
7. n - suppress print of text that do not match a filter (accompanied by p flag)
8. = - prints line numbers along with the text of string file/stream
9. l - list command to show non printable characters in text
10. w - write edits to file
11. r  - reading text from one file and inserting/appending to another file.

used to edit text without interactiving with the file on console. i.e. this can edit text in the background by means of appropriate sub-commands of sed. 

---------------------------------------------------------------
1. Substituting a text
---------------------------------------------------------------

echo "this is a sample text" | sed 's/text/test/'

-> this is a sample test

echo "this is a sample text" |sed 's/t/T/'   --> substitute first occurances
-> This is a sample text

echo "this is a sample text" |sed 's/t/T/g'  --> substitute file contents globally
-> This is a sample TexT


NOTE -  In this case, Sed editor will not alter the content of the file. but only changs the output of the tetxt returned in he current stream. So the file content is preseved.


---
cat file
this is a trial text
---

-----END a command argument with / -----
eg-0
cat file | sed 's/t/T/'
This is a trial text


eg-1
cat file | sed 's/t/T ;s/r/g'
sed: -e expression #1, char 10: unknown option to `s'

eg-2
cat file | sed 's/t/T/;s/r/g'
sed: -e expression #1, char 12: unterminated `s' command
---
eg-3  (multiple substitutions)
cat file | sed 's/t/T/;s/r/g/'
This is a tgial text
---
eg-4 
cat file | sed 's/t/T/g;s/i/g/'
This is a Trial TexT

---
eg-5   - 2nd occurrence (nth occurrence)

cat file | sed 's/t/T/g;s/i/2/'
this is a Trial text

--------
alternate syntax

sed 's/t/T/g;s/i/g/g' file
here the command is written as - sed 'script' <filename>

-----
multiple edits in file with -e option

sed -e '
s/is/a/
s/tr/ST/
s/al/AM/' file

-> tha is a STiAM text

------

save the file edits in the file
-in-line edits -i

sed -ie '
s/is/a/
s/tr/ST/
s/al/AM/' file

-> tha is a STiAM text
- the file will get edited as -i is used to set the file content edit. 

-----------------------

saving sed command in a script file

whatever we can write as sed commands, we can save a a script file and call them as arguments while editing files. 
usecase: This can help in quickly editing similar files in future. 

cat script
s/is/a/
s/tr/ST/
s/al/AM/

sed -f <script> <file>

-----------------------

write change to source file (in place editing) -> -i 

cat -f <script> <file> -i

--------------------------

edit 2nd occurrence of the text

cat file
-> this is a trial text

sed 's/t/T/2' file
-> this is a Trial text

This applies to the 'nth' occurrence of the text in a single line. If the nth occurrence is not found due to overflow, then no error is thrown.

----------------------------
p flag - print the occurrence

cat file 
-> this is a trial text

sed 's/t/T/p' file
-> This is a trial text
   This is a trial text

----------------------------
another example p flag

cat file
1 a a b b
2 c c d d

----
sed 's/a/A/2' file
1 a A b b
2 c c d d
---

sed 's/a/A/2p' file
1 a A b b
1 a A b b
2 c c d d

---
-n flag -> generally used along with p flag to print ONLY edited lines
-n flag -> suppress output
---

sed -n 's/a/A/2p' file
1 a A b b
---
sed -n 's/d/D/1p' file
2 c c D d

----
NOTE: if we use -n without p flag, there will be no output.

-----

to write the edited line to a new file.
w flag - write w flag instead of p flag to write the output to new file instead of printing
------
sed -n 's/d/D/w new' file
cat new
-> 2 c c D d
----

using ! exclamation mark as string delimiter

cat file
-> /home/admin

sed 's!/home/admin!/home/yuvraj!' file
-> /home/yuvraj/

-----
Line addressing  - to apply edits to specific lines
There are 2 types of line addressing
- numeric line addressing
- text filters line addressing


usecase : uncommenting specific lines in configuration files by script
eg: 
echo "120s/#//p" > sedscript
sed -n -f sedscript sample-configuration-file 

usecase : uncommenting multiple lines in configuration files by script
eg:
existing file content :

head -121 sudoexfile | tail -2
# Sudo debug files:
#   Debug program /path/to/debug_log subsystem@priority[,subsyste@priority]

edited file content (not written to file in this case):
echo "120,121s/#//p" > sc
sed -n -f sc sudoexfile 
 Sudo debug files:
   Debug program /path/to/debug_log subsystem@priority[,subsyste@priority]

edit file content (written to file):
sed -n -i -f sc sudoexfile 

head -121 sudoexfile | tail -2
 Sudo debug files:
   Debug program /path/to/debug_log subsystem@priority[,subsyste@priority]
---

Line Addressing - to edit text in specific lines

----
eg:
cat file
This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

-----
eg: edit only 3rd line (Edits Only line #3) (use comma separated numbers to edit more lines)

sed "3s/line/Line/" file3
This is the first line in the text
This is the second line in the text
This is the third Line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

-----.

eg: edit the second "the" in each line

sed "s/the/THE/2" file3

sed "s/the/THE/2" file3
This is the first line in THE text
This is the second line in THE text
This is the third line in THE text
This is the fourth line in THE text
This is the fifth line in THE text
This is the sixth line in THE text
This is the seventh line in THE text
This is the eighth line in THE text
This is the nineth line in THE text
This is the tenth line in THE text

----

eg: edit the second "the" in ONLY the Second line

sed "2s/the/THE/2" file3
This is the first line in the text
This is the second line in THE text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

-----
Edit Range of Line Numbers.
---------------------------
eg: edit the second "the" in lines 2 to 5 

sed "2,5s/the/THE/2" file3
This is the first line in the text
This is the second line in THE text
This is the third line in THE text
This is the fourth line in THE text
This is the fifth line in THE text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

----

eg: Edit  second "the" from 5th line to LAST Line in the file
sed '5,$s/the/THE/2' file3
This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in THE text
This is the sixth line in THE text
This is the seventh line in THE text
This is the eighth line in THE text
This is the nineth line in THE text
This is the tenth line in THE text

---

Line Addressing by Text filter - Edit lines that contain specific text

----

eg: Edit line that contains "nth" - change the second occurrence of "the" to "THE"

sed '/nth/s/the/THE/2' file3
This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in THE text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in THE text

------------------------------------------------------------------------------
2. DELETING Text from a file
------------------------------------------------------------------------------
cat file3
This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

------------
eg: Delete Line 3 from the file
sed '3d' file3
This is the first line in the text
This is the second line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text
------------

Delete Range of lines
eg: delete lines 3 to line 6 

sed '3,6d' file3
This is the first line in the text
This is the second line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

--------------------

Delete from line "n" to last line. 

eg: delete line 3 to end of line

sed '3,$d' file3
This is the first line in the text
This is the second line in the text

---------------------

Deleting line containing text filter

eg: Delete line containing "third" in the text

sed '/third/d' file3
This is the first line in the text
This is the second line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text
---------------

Combining Deleting and Editing 2 different lines in the text.

eg: delete third line, edit 2nd occurrence of text pattern in 4th line

sed '/third/d;4s/the/THE/2' file3
This is the first line in the text
This is the second line in the text
This is the fourth line in THE text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

-----------

3. Insert line of text before a specified line
4. Append line of text After a specified line

--------------------------------------------

simple example:
echo "line 2" | sed 'i\inserted line' 
inserted line
line 2

---------------------------------------------

echo "line 2" | sed 'a\appended line' 
line 2
appended line
------------------------------------------------

Inserting Before "nth" line in file

eg: insert line of text before 3rd line in file

sed '3i\inserted line' file3 
This is the first line in the text
This is the second line in the text
inserted line
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

--------------------------------------

Inserting Before "nth" line in file

eg: insert line of text before LAST line in file

sed '$i\inserted line' file3 
This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
inserted line
This is the tenth line in the text

-------------------------------------------

Insert Before 1st Line of file

sed '1i\inserted line' file3 
inserted line
This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text
-----------------------------------------------

APPENDING
--------------------------------------------------

Appending line of text after last line of text

sed '$a\inserted line' file3 
This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text
inserted line

--------------------

eg: appending after 1st line of text

sed '1a\inserted line' file3 
This is the first line in the text
inserted line
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

---------------------------------------------------------------
5. Transform characters - one to one - i/o character mapping
---------------------------------------------------------------

echo "transform block from abc to cac"  | sed 'y/ab/ca/'

trcnsform alock from cac to ccc


NOTE: This is ONLY for characters, not strings. 
eg: error - only use one-to-one character mapping

sed 'y/h/ca/' file3
sed: -e expression #1, char 7: strings for `y' command are different lengths

-----
eg: 
sed 'y/h/c/' file3
Tcis is tce first line in tce text
Tcis is tce second line in tce text
Tcis is tce tcird line in tce text
Tcis is tce fourtc line in tce text
Tcis is tce fiftc line in tce text
Tcis is tce sixtc line in tce text
Tcis is tce seventc line in tce text
Tcis is tce eigctc line in tce text
Tcis is tce ninetc line in tce text
Tcis is tce tentc line in tce text

-------

Transforming multiple characters in one command.. just add more characters to the map

sed 'y/hn/cm/' file3
Tcis is tce first lime im tce text
Tcis is tce secomd lime im tce text
Tcis is tce tcird lime im tce text
Tcis is tce fourtc lime im tce text
Tcis is tce fiftc lime im tce text
Tcis is tce sixtc lime im tce text
Tcis is tce sevemtc lime im tce text
Tcis is tce eigctc lime im tce text
Tcis is tce mimetc lime im tce text
Tcis is tce temtc lime im tce text

----------

Apply transformation to specific line

sed '3y/hn/cm/' file3
This is the first line in the text
This is the second line in the text
Tcis is tce tcird lime im tce text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

------------------------

Apply transformation to a range of lines

sed '6,$y/hn/cm/' file3
This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
Tcis is tce sixtc lime im tce text
Tcis is tce sevemtc lime im tce text
Tcis is tce eigctc lime im tce text
Tcis is tce mimetc lime im tce text
Tcis is tce temtc lime im tce text

----------------------------------------------------------------
6. Print lines of text that match a filter
----------------------------------------------------------------
sed '3,4p' file3
This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the third line in the text
This is the fourth line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

print range of lines , along with the original text
sed '9,$p' file3
This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the nineth line in the text
This is the tenth line in the text
This is the tenth line in the text


print lines that match a text filter
sed -n '/third/p' file3
This is the third line in the text

------------------------------------------------------------------
7. suppress printing of lines of text that DO NOT match a filter
------------------------------------------------------------------
sed -n '9,$p' file3
This is the nineth line in the text
This is the tenth line in the text

-----------------------------------------------------------------
8. prints line numbers of text along with the file
-----------------------------------------------------------------

sed '=' file3
1
This is the first line in the text
2
This is the second line in the text
3
This is the third line in the text
4
This is the fourth line in the text
5
This is the fifth line in the text
6
This is the sixth line in the text
7
This is the seventh line in the text
8
This is the eighth line in the text
9
This is the nineth line in the text
10
This is the tenth line in the text

---------------------------------------------------------------
9. list non-printable characters in a text
---------------------------------------------------------------

cat file4
Hi      This
is      a       file
with some
        unprintable characters.


Find if the file has unprintable characters by listing them.

sed -n 'l' file4
Hi\tThis\t$
is\ta \tfile$
with some\t$
\tunprintable characters.$

-----------------------------------------------------------------

10. Write edits to file 
-----------------------------------------------------------------
Write specific line numbers to file

sed -n '1,2w writefile' file3

cat writefile
This is the first line in the text
This is the second line in the text

------------------------------------------------------------------

Write specific line to file by text filters

sed -n '/nineth/w writefile' file3

cat writefile
This is the nineth line in the text

-------------------------------------------------------------------
11. Insert content of one file into another file
-------------------------------------------------------------------
cat file2
1 i i i i
2 i i i i
3 j j j j


# insert file2 content after 3rd line in file3

sed '3r file2' file3  

This is the first line in the text
This is the second line in the text
This is the third line in the text
1 i i i i
2 i i i i
3 j j j j
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

cat file3
This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text


#insert text from file2 into file 3 after EVERY line containing text "sixth"

sed '/sixth/r file2' file3

This is the first line in the text
This is the second line in the text
This is the third line in the text
This is the fourth line in the text
This is the fifth line in the text
This is the sixth line in the text
1 i i i i
2 i i i i
3 j j j j
This is the seventh line in the text
This is the eighth line in the text
This is the nineth line in the text
This is the tenth line in the text

-------------------------------------------------------
