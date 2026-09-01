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

