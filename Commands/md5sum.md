# Linux `md5sum` Command

THe `md5sum` command calculates and verifies an **MD5 checksum** for files or input.

It is commonly used to:
- Check file integrity
- Verify downloaded files
- Compare whether two files are identical
- Detect accidental file corruption

> MD5 is useful for integrity checking, but it is **not considered secure for cryptographic purposes** because collisions can be created.

---

## Key Points

- `md5sum FILE` = generate an MD5 checksum
- `md5sum -c FILE` = verify checksums
- Same file content -> same checksum
- Any content change normally produces a different checksum
- MD5 produces a **128-bit hash**, usually shown as 32 hexadecimal characters
- `md5sum` can also read from standard input

---

## 1. Basic Syntax

```bash
md5sum [OPTION] FILE
```

Example:
```bash
md5sum file.txt
```

Output:
```bash
098f6bcd4621d373cade4e832627b4f6  file.txt
```

The first part is the checksum:
```
098f6bcd4621d373cade4e832627b4f6
```

---

## 2. Generate a Checksum

```bash
md5sum file.txt
```

Example:
```bash
md5sum ubuntu.iso
```
This calculates the MD5 checksum of the file.

---

## 3. Compare Two Files

Generate checksums for both files:
```bash
md5sum file1.txt file2.txt
```

If the checksums are identical:
```
abc123...  file1.txt
abc123...  file2.txt
```
then the contents are identical.

If one file changes, its checksum changes.

---

## 4. Save a Checksum

```bash
md5sum file.txt > checksum.md5
```

The file contains:
```bash
098f6bcd4621d373cade4e832627b4f6  file.txt
```

---

## 5. Verify a Checksum

Use:
```bash
md5sum -c checksum.md5
```

If the file is unchanged:
```
file.txt: OK
```

If the file has changed:
```
file.txt: FAILED
```

---

## 6. Typical Integrity Check

Create checksum:
```bash
md5sum file.txt > file.md5
```

Later verify:
```bash
md5sum -c file.md5
```

Flow:
```
File -> md5sum -> Checksum saved -> Verify later with -c
```

---

## 7. Read From Standard Input

```bash
echo -n "hello" | md5sum
```

Output:
```
5d41402abc4b2a76b9719d911017c592  -
```
The `-` means the data came from standard input.

### Important

These are different:
```bash
echo "hello" | md5sum
```
and:
```bash
echo -n "hello" | md5sum
```
because normal `echo` adds a newline.

---

## 8. Verify a Download

A website may provide:
```
d41d8cd98f00b204e9800998ecf8427e
```

Calculate your downloaded file:
```bash
md5sum downloaded.iso
```

Compare your checksum with the provided checksum.

If they match, the file was likely downloaded without accidental corruption.

---

## 9. Useful Options

|Option|Meaning|
|---|---|
|`-c`|Check hashes from a checksum file|
|`--quiet`|Do not print `OK` for successful checks|
|`--status`|Produce no output, use exit status|
|`--ignore-mising`|Ignore files that are missing|
|`--warn`|Warn about malformed checksum lines|

---

## 10. Check Exit Status

Run:
```bash
md5sum -c checksum.md5
```

Then:
```bash
echo $?
```

Typical result:
```
0 -> verification successful
non-zero -> verification failed
```
This is useful in scripts.

Example:
```bash
if md5sum -c checksum.md5; then
    echo "File verified"
else
    echo "Verification failed"
fi
```

---

## 11. MD5 vs SHA

Modern systems usually prefer SHA algorithms for stronger integrity/security requirements.

```bash
sha256sum file.txt
```

Common commands:
|Command|Algorithm|
|---|---|
|`md5sum`|MD5|
|`sha1sum`|SHA-1|
|`sha256sum`|SHA-256|
|`sha512sum`|SHA-512|

For modern verification, prefer:
```bash
sha256sum
```
when SHA-256 checksums are available.

---