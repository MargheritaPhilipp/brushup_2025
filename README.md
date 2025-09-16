### DSDM Brushup - 2025 coding

This repository contains files for the coding brushup of the BSE [Data Science for Decision Making programme](https://bse.eu/masters-degrees/data-science/data-science-decision-making). 

It it possible to generate the exact virtual environment used to run the notebooks via the uv.lock file (`uv sync`).

In order to access the data, download the full [data folder](https://drive.google.com/drive/folders/1v5LPtVH3DDpu4Hj3Df7W8VfqMpqCFtiF?usp=drive_link) and save it locally in the way indicated by the file tree below.

You can find the matching [slides](https://drive.google.com/drive/folders/1mcjGxhuuWn0QhBGkHkn8kaV_63d1a4S5?usp=sharing) on drive.

📂files\
┣ 📂1_quiz\
┣ 📂2_temp\
┣ 📂3_basics\
┣ 📂4_directories_programming\
┣ 📂5_EDA\
┗ 📂data\
&nbsp;&nbsp;┣ 📂text_fun\
&nbsp;&nbsp;┣ 📂WB_extra\
&nbsp;&nbsp;┣ 📜country_isocode_regions.csv\
&nbsp;&nbsp;┣ 📜text_judiciary_weakened.csv\
&nbsp;&nbsp;┗ 📜WB_pop_clean.csv\
📜.gitignore\
📜main.py\
📜pyproject.toml\
📜README.md\
📜uv.lock\


|  # | Title| Students can…|
| -: | ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|  1 | VSC, virtual environments                        | - open a project folder in VSC<br>- use UV to initialise a project and add packages<br>- select an environment for a py script or notebook<br>- run code in .py files and notebooks                                                                                                                                                                                                                                                                                                                       |
|  2 | Version control                                  | - clone a repository locally<br>- publish a local project on GitHub<br>- stage, commit and merge changes<br>- use .gitignore to avoid uplpading files and folders<br>- enter the GitHub danger zone of changing visibility or deleting repositories<br>- generate readme files with hyperlinks and repository trees                                                                                                                                                                                                                 |
|  3 | Colab & Python basics                            | - load files in a colab notebook through drive, a link to a sheet or dropbox<br>- format text in markdown<br>- give example of data types (numeric, string, boolean, non-type) and convert between them<br>- explain differences between sequence types (lists, tuples, ranges)<br>- explain the risks of overwriting and the benefits of creating (deep) copies<br>- use operands on datatypes and sequences<br>- use comparative operators (`>`, `<`, `>=`, `<=`, `==`, `!=`)<br>- use basic if else logic<br>- create a while loop<br>- loop over iterables (strings, range, lists, set, tuple, rows of data frames)<br>- create data frames from dictionaries<br>- read basic list comprehensions                                                                                                                |
|  4 | Directories, functions & classes, combining data | - find documenation for packages online or locally<br>- use os to import files from relative paths (including from parent directories), and to create new directories<br>- use python's open() function to read and write .txt files<br>- explain the differences between object oriented vs functional programming<br>- name parts of a function (input, output)<br>- read and write simple full (named) and lambda (anonymous) functions<br>- combine functions with .map(), filter() and pandas's .apply()<br>- name parts of a class (input, method, attribute)<br>- instantiate a pre-defined class and call methods and attributes<br>- combine dataframes in suitable ways (join, concat, merge)                                                                                                              |
|  5 | EDA and feature creation in python               | - import csv files, save dataframes as csv files<br>- inspect basics of a data frame (shape, head, columns, info, describe, nlargest, (n)unique, value\_counts)<br>- subset data frames (loc and iloc)<br>- find and remove outliners<br>- plot basic boxplots, histograms and kernel densities<br>- create simple features with operations on columns (+, \_, \*. /)<br>- transpose data frames and select row as heading<br>- interpret basic error messages and find suitable fixes (converting types)<br>- explain the value of (and differences between) melting and pivoting<br>- explain the use of .reset\_index()<br>- use split() and simple regex searches to work with text as data and generate simple features                                                                                         |
|  6 | EDA and feature creation in python & in R        | - rename columns with a dictionary<br>- inspect missingness and dropping rows for a subset of columns with missing values<br>- use groupby and .agg(), including with dictoranies and deal with multi-level column headings<br>- generate features based on .diff() and mapping a lambda function<br>- critically reflect on the use of subplots, e.g. for scatter and boxplots<br>- R: name key differences and similarities between R and Python as well as the interfaces of RStudio and VSC<br>- R: import (and save) csv files and inspect basics of a dataframe (equivalent to python ones in previous lesson)<br>- R: subeset data, rename columns, melt and pivot, convert between data types<br>- R: inspect missingness and remove rows with missing values, generate visuals (e.g. box and scatter plots) |