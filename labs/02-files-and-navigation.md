# Files and Navigation

Date: 2026-10-16  
Environment: Home lab — Ubuntu 24.04.4 LTS  
Working directory: `/home/hanlong/linux-labs/02-files`

## Objective

Practise navigating directories, managing files and inspecting their contents.

## 1. Create the Working Directory

Commands:

```bash
mkdir -p ~/linux-labs/02-files
cd ~/linux-labs/02-files
pwd
```

Output:

```text
/home/hanlong/linux-labs/02-files
```

Explanation:

* `mkdir -p` creates the directory and any missing parent directories.
* `~` expands to the user's home directory.
* `cd` changes the shell's working directory.
* `pwd` prints its absolute path.

## 2. Create and Read a File

Commands:

```bash
printf 'Linux home lab\nPractising file navigation\n' > notes.txt
ls -l notes.txt
cat notes.txt
```

Output:

```text
-rw-rw-r-- 1 hanlong hanlong 42 Oct 16 09:55 notes.txt
Linux home lab
Practising file navigation
```

Explanation:

* `printf` produces formatted text; `\n` inserts a newline.
* `>` redirects output to a file, replacing existing contents.
* `ls -l notes.txt` shows the file's permissions, owner, group, size and timestamp.
* `cat notes.txt` displays its contents.

## 3. Copy and Rename

Commands:

```bash
cp notes.txt notes-backup.txt
mv notes-backup.txt archive.txt
ls -l
```

Output:

```text
total 8
-rw-rw-r-- 1 hanlong hanlong 42 Oct 16 09:57 archive.txt
-rw-rw-r-- 1 hanlong hanlong 42 Oct 16 09:55 notes.txt
```

Explanation:

* `cp` creates a separate copy named `notes-backup.txt`.
* `mv` renames that copy to `archive.txt`; the original `notes.txt` remains.
* The final files are `notes.txt` and `archive.txt`.

## 4. Compare and Append

Commands:

```bash
diff notes.txt archive.txt
printf 'Updated original file\n' >> notes.txt
diff notes.txt archive.txt
```

Output:

```text
3d2
< Updated original file
```

Explanation:

* The first `diff` produces no output because the contents match.
* `>>` appends text to the file.
* `3d2`: delete line 3 from the first file to make it match the second, after line 2.
* `<`: this line comes from the first file, `notes.txt`.

## 5. Move Files and Navigate Directories

Commands:

```bash
mkdir archive
mv archive.txt archive/
cd archive
pwd
cat notes.txt
cat ../notes.txt
```

Output:

```text
/home/hanlong/linux-labs/02-files/archive
cat: notes.txt: No such file or directory
Linux home lab
Practising file navigation
Updated original file
```

Explanation:

* `cat notes.txt` fails because the file is not in the current directory, `archive`.
* `..` refers to the parent directory, so `cat ../notes.txt` reads the original without changing directories.

## 6. Independent Exercise

Task: Return to the parent directory, create reports, copy notes.txt
as reports/summary.txt and read it without entering reports.

Commands:

```bash
cd ..
mkdir reports
cp notes.txt reports/summary.txt
cat reports/summary.txt
```

Output:

```text
mkdir: cannot create directory ‘reports’: File exists
Linux home lab
Practising file navigation
Updated original file
```

Explanation:

* `mkdir` fails because `reports` already exists; the directory remains usable.
* Both paths in `cp` are relative to `/home/hanlong/linux-labs/02-files`.
* `notes.txt` is the source; `reports/summary.txt` is the destination copy.
* An ordinary `cp` overwrites an existing destination file.
* `cat` reads the copy without changing the working directory.

## 7. Find Files and Search Contents

Commands:

```bash
find . -type f
grep -n 'Updated' notes.txt reports/summary.txt
```

Output:

```text
./notes.txt
./archive/archive.txt
./reports/summary.txt
notes.txt:3:Updated original file
reports/summary.txt:3:Updated original file
```

Explanation:

- `find` searches the current directory (`.`) and its subdirectories.
- `-type f` selects regular files; the displayed paths are relative to `.`.
- `grep -n` searches the two named files for `Updated`, showing filename, line number and matching text. Both matches are on line 3.
- The archived copy was created before the append. It should lack the new line, but this search does not inspect it.

## 8. Inspect the Beginning and End

Commands:

```bash
head -n 2 notes.txt
tail -n 1 notes.txt
```

Output:

```text
Linux home lab
Practising file navigation
Updated original file
```

Explanation:

* `head -n 2` displays the first two lines; `tail -n 1` displays the last line.
* Neither command changes the file.

## 9. Relative Path Challenge

Task: From inside reports, copy the archived file into the current
directory as original.txt.

Commands:

```bash
cd reports
cp ../archive/archive.txt original.txt
cat original.txt
```

Output:

```text
Linux home lab
Practising file navigation
Updated original file
```

Explanation:

* From `reports`, `../archive/archive.txt` goes up to the parent and then into `archive`.
* `original.txt` is created in the current directory, `reports`.

**Verification pending:** the recorded output includes `Updated original file`, but the archived copy should contain only the first two lines. Re-run `cat ../archive/archive.txt` and `diff ../archive/archive.txt original.txt` from `reports`. Confirm whether the archive changed and update this record with the actual result.

## What I Learned

- `~` expands to my home directory, `/home/hanlong`.
- Absolute paths start at `/`; relative paths start from the current directory.
- `.` means the current directory; `..` means its parent.
- `>` replaces file contents; `>>` appends.
- `cp` creates a separate copy; `mv` moves or renames a file.
- A successful `diff` with no output means the file contents match.

## Mistakes and Corrections

- Reading `notes.txt` from `archive` failed; `../notes.txt` points to the correct location.
- Creating an existing directory failed; I could still use that directory.
- My first relative-path answer omitted `../`; paths depend on the current directory.
