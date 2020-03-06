# re
The Reach Recent Command for Unix

The `re` command aims to make `cd` operations more efficient
when targeting recently used folders in a deep hierarchy.

There are two essential features:

   - `re` list (in-depth) subdirectories by order of last modification,
   - `re foo` restricts the output to directories whose name includes `foo`.

One can then type in a digit to select the desired directory to `cd` into.
Or simply type `enter` to validate the first choice.
In case there is a single result, it is automatically selected.

The efficient way to integrate the `re.sh` script in one's shell is by adding
the following alias into `.bashrc`:

``
   alias re='. ~/re.sh 8'
``

Where the parameter `8` bounds the number of result to display.

General usage:

```
     . re.sh nb_results [folder_name_pattern]
```

where:

   - `nb_results` is the maximal number of folders to display,
   - `folder_name_pattern` restricts the recent folders to those
      that contain the pattern in their name (i.e., syntactic substring).

Known issue:

    - limitations when filtering folders whose name includes spaces,
    - hidden folders are excluded, it might be useful to provide an option to include them,
    - it might be useful to include an option to exclude folder on remote servers from the search.
