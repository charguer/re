# re
The Reach Recent Command for Unix

The `re` command aims to make `cd` operations more efficient
when targeting recently used folders in a deep hierarchy.


Feature 1: `re` without argument
================================

The `re` command, when invoked without arguments, displays a list of 
the subdirectories (possibly in-depth), that were most recently updated.

For example:

```
   ~/perso$re
   1: ./work/review/2020-10/
   2: ./admin/school/2020/report
   3: ./admin/
   4. ./sport/biking/map_castle
   5: ./
   6: ./fun/jokes/others
   7: ./fun/movies
   8: ./work/
   choice?
```

To `cd` into one of these directories, it suffices to type in the corresponding
digit. As a shorthand, to validate the first choice, simply type `enter`.

The maximal number of listed subdirectories is 8 by default, but this 
number can be customized. 


Feature 2: `re` with an argument
================================

The command `re foo` restricts the output of `re` to (possibly in-depth)
subdirectories whose name includes `foo`.

For example:

```
   ~/perso$re bik
   1: ./work/review/2020-10/minibikes
   2: ./fun/movies/bikers
   3: ./admin/insurance/motorbike
   choice?
```

Again, the desired directory can be selected by typing the corresponding digit.
In the relatively common case where a single result shows up, that result is
automatically selected. 

For example, assuming the pattern `minibik` occurs in exactly one subdirectory,
the command `re minibik` directy `cd` to that folder:

```
   ~/perso$re minibik
   ~/perso/work/review/2020-10/minibikes$
```



Installation
================================

Download the script `re.sh` (e.g., in your home), then add the following
line to your `~/.bashrc` file.

```
   alias re='. ~/re.sh 8'
```

Where the number `8` denotes the maximal number of result to display.


Limitations
================================

Limitations include:

- hidden folders are excluded, it might be useful to provide an option to include them,
- it might be useful to include an option to exclude folder on remote servers from the search,
- it could be useful to integrate a default 1sec timeout to the command, when exploring file systems that are too large.
