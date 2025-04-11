# awk -   Alfred V. Aho, Peter J. Weinberger, Brian W. Kernighan. (1977)

# awk <-- Aho, Weinberger, Kernighan
-----------------------------------------------------
versatile cli tool - to process and manipulate text data.

 How it works 
	reading input line by line, 
	splitting each line into fields, and then 
	performing actions based on patterns you define.

----------------------------------------------------

# Some use-cases of awk
----------------------------------------------------
1. Extracting Specific Columns or Fields:
2. Filtering Lines Based on Conditions:
3. Reformatting Output:
4. Performing Calculations and Aggregations
5. Processing Log Files:
6. Data Transformation and Manipulation:
7. Generating Reports
8. As a Filter in Pipelines
9. Arithmetic operations from text files
----------------------------------------------
# Key Concepts in awk:
----------------------------------------------

Records: By default, each line in the input is treated as a record.

Fields: Within each record, fields are separated by a field separator (default is whitespace). You can change the field separator using the -F option.

Patterns: Conditions that determine which records to process.

Actions: Commands to be executed when a pattern matches. Actions are enclosed in curly braces {}.

Variables: awk supports built-in variables (like NR for record number, NF for number of fields) and user-defined variables.

Arrays: awk supports associative arrays, which are very useful for counting and grouping data.

Built-in Functions: awk has many built-in functions for string manipulation, arithmetic operations, and more.

---------------------------------------------
# Some basic examples of awk usage
---------------------------------------------
	eg:
	awk -F':' '{print $1, $3}' /etc/passwd
	where,
	-F -> to define field separator
	print -> to define what to print
	$1, $3 -> fields, 1 and 3 separated by a space. 


Filtering Lines Based on Conditions:
-----------
eg: 
awk '/text-pattern/' file.txt

prints the lines from the file that contain the text pattern.

----------

eg: 
Displaying lines where the third field (e.g., a status code) is greater than 400:

awk '{if ($3 > 400) print}' access.log

print the line if third field is greater than 400.

-----------

eg:

Rearranging columns in a CSV file:

awk -F',' '{print $3 "," $1 "," $2}' data.csv

------------------------------------------------------------------------------------

We will check the usage of awk for the following cases. 

- Analysing logs using capabilities such as built in variables, positional variables, print etc.

- Print outputs, select specific lines

- Apply control structure and use loops in awk 

- Use functions and data transformation

- format and debug awk programs

- Search and modify text in files using regular expressions

--------------------------------------------------------------------------------------------
# Some Predefined and automatic variables in awk
--------------------------------------------------------------------------------------------
RS - record separator
	awk processes data, one record at a time. 
	The RS is the delimiter to split the input data stream into records. 
	Default is newline character. 
	so by default, it 1 record is 1 line

NR - current input record number
	this matches with the current input line number

FS/OFS - field separator / Output field separator
	- delimiter for the input string, delimiter for the output string.
	- default is white space

NF - number of fields in the current record. 

$0 - The symbol $0 shall refer to the entire record;
-------------------------------------------------------------
# Some Basic Usage of awk
-------------------------------------------------------------
AWK programs are made of one or many pattern { action } statements.

awk '1 { print }' file  # prints the file as it is 
			# reason : here, the syntax is 
			# awk '<non-zero value> {action}' file

in awk, a non-zero value indicates true for an evaluation. 

hence, the following does not return anything
awk '0 { print }' file  # prints nothing. (0 returns false on evaluation)

-------------------------------------------------------
Also, print - is the default action. 
so the above can be shortened. 

awk 1 file 		# prints the file as it is, as default action is to print

-------------------------------------------------------
# removing a file header  - 
# (print anything that has a record number of more than 1)
-------------------------------------------------------
awk 'NR>1' file

OR

awk 'NR>1 {print} file
-------------------------------------------------------

---
#Printing a range of records
awk 'NR>1 && NR<3 {print}' textfile
OR
awk 'NR>1 && NR<3' textfile
---

#Printing record number of filtered records
awk 'NR>1 && NR<3 {print NR} ' textfile
---
#printing filtered records, along with record number
awk 'NR>1 && NR<3 {print NR, $0 } ' textfile
---
#printing lines along with number of fields in each line (prints all lines)
awk '{print NF, $0 }' textfile
---
#printing lines and number of fields in each line (ONLY non-empy lines)
awk 'NF {print NF, $0 }' textfile
---
#THEREFORE, printing ONLY NON-Empty lines
awk 'NF' textfile
---
POSIX rule that specifies if the RS is set to the empty string, “then records are separated by sequences consisting of a <newline> plus one or more blank lines.”
---
#printing specific fields with specific separators (in the case, 'comma')
awk 'NF {print $1, $2, $3,}' OFS=, textfile

---
To initialize those variables before the first record is read. 
Use a special BEGIN block inside the AWK program 

---
#(print text based on One pattern OR another pattern (multiple patterns with OR logic))
awx '/pattern1/||/pattern2/' textfile
---


-------------------------------------------

#printing a range specified by text filter
eg: print range of lines from first occurrence of pattern1 to last occurrence of pattern2
awk '/pattern1/,/pattern2/' textfile

------------------------------------------

&& and || are used to specify AND and OR condition in the patterns.

eg:
awk '/pattern1/&&/pattern2/||/pattern3/&&/pattern4/' textfile
here, we want to print fields, which have 
pattern1 AND pattern2
OR
pattern3 AND pattern4

---------------------------------
# BEGIN and END
---------------------------------
awk has these two important keywords. 
BEGIN - Actions in this block are executed before awk takes any input from the text file
END - Actions in this block are executed after the text file is processed completely.

eg:
awk 'BEGIN {print "Records\n---------";} {print $1,"\t",$3;} END {print "completed\n-----";}' textfile


---------------------------------------
# Filtering records by Conditions
---------------------------------------

to filter the records by condition, 
we can use a combination of logical operators, comparison operators, 
positional arguments to address fields of a record, and regular expressions. 

eg: to print data from a file, by checking the filter on column 5, equal to "INR" and column 2 being less than 5, 

awk 'BEGIN {print "filtered text \n";} '$2<5 && $5=="INR"'  print{$1, "-", $5}' textfile

-----------------------------------------
# awk program file
-----------------------------------------

The same awk conditions and actions can be written in terms of a file

cat awkfile.awk
'BEGIN {print "filtered text \n";} '$2<5 && $5=="INR"'  print{$1, "-", $5}' 

awk -f 'awkfile.awk' textfile

# The same awkfile program can be used on multiple files in the same command. 
# This will be executed sequentially

awk -f 'awkfile.awk' textfile1 textfile2 ... textfilen


---------------------------------------------------
# sample awk program to add a total of price based on conditional blocks and case-insensitive comparison.
---------------------------------------------------

BEGIN {FS="\t"; total = 0 } 
# initialize a "total" variable and set the Field Separator as required.
{
	if(toupper($3)== "BLR" && toupper($9)== "Y" && toupper($4)=="DEL" ) 
	# toupper - to convert the string to uppercase, to support case-insensitive comparison.
	{
		total += $8;	# incrementing operator to add value to "total" variable
		print $0	
		# print the record when "if" condition is true
	}	# if block ends
	else if(toupper($3)=="DEL" && toupper($9)=="Y" && toupper($4)="IXG")	# else if block
	{
		total += $8;
		print $0	
		# print the record when the "else if" condition is true
	}	# else-if block ends

}
END{
print "Total Amount = $"total  # incremented total is printed
}
---------------------------------------------------
# I realised - case-insensitive string comparison happens to be very valuable in the right conditions. 
---------------------------------------------------

# Sample awk program to add the 10th field in all records in a file, and return the total. 

awk 'BEGIN{ sum=0; FS="\t" }  { sum +=$10; print $10; }  END{ print sum }' textfile

---------------------------------------------------
# simple awk program to print the last record of a text file

awk 'END{ print $0 }' textfile
---------------------------------------------------

# some operators in awk

------------------------------------------------

standard arithmetic operators
	 +, -, *, /, % (modulo), and ^ (exponentiation). 
 
 ------------------------------------------------

comparison operators (==, !=, >, >=, <, <=)

------------------------------------------------

logical operators (&&, ||, !)

------------------------------------------------

assignment operators (=, +=, -=, *=, /=, %=, ^=).

------------------------------------------------
regular expression matching operators ( ~, !~)
------------------------------------------------

string ~ regexp: This expression is true if the string matches the regular expression regexp. It returns 1 (true) if there is a match, and 0 (false) otherwise.

BEGIN { FS = ":" }
/root/ { print "Line contains 'root':", $0 }
$1 ~ /user/ { print "Username contains 'user':", $0 }
$3 ~ /[0-9]{3}/ { print "UID is a 3-digit number:", $0 }

HERE; 
/root/ is a shorthand for $0 ~ /root/, meaning "if the entire current line ($0) matches the regular expression root".
$1 ~ /user/ checks if the first field ($1) matches the regular expression user.
$3 ~ /[0-9]{3}/ checks if the third field ($3) matches a regular expression that represents three consecutive digits.

string !~ regexp: This expression is true if the string does not match the regular expression regexp.
BEGIN { FS = ":" }
$7 !~ /bash$/ { print "User does not have bash as their shell:", $0 }
#This would print lines from /etc/passwd where the seventh field (the shell) does not end with "bash".

Key Points about the ~ operator:

It performs a regular expression match. The regexp on the right-hand side is treated as an extended regular expression (ERE) by default in most awk implementations (like gawk).
It's a binary operator, taking a string on the left and a regular expression on the right.
It returns a boolean value (represented as 1 or 0).

------------------------------------------------
