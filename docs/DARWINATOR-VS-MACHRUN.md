# Keka command line tools: machrun vs darwinator (2026-11-24)

Same test (`darwinator-apps/keka.sh`, Keka 1.6.8, original Mach-O files) on the pearOS image VM (FreeBSD 14.5, `darwinator-old.ko`, `kern.darwinator.dyld=1`).
`MACHRUN=env` with `binmiscctl disable macho64 machofat` makes the kernel (darwinator) start the Mach-O file directly; the binmisc entries were enabled again after the run.

| path | ok | FAIL |
|---|---|---|
| machrun (binmisc interpreter) | 37 | 0 |
| darwinator direct | 28 | 9 |

The 9 failures, direct run only: `kekalz4`, `kekazstd compress`, `kekatar` (extract 7zip, gnutar, pax, ustar, zip, system tar, decrypt AES zip).
Causes seen (not yet fixed):
- `h.txt: Can't restore time: Invalid argument`: a time-setting syscall (utimensat/futimes family) returns EINVAL under darwinator.
- `kekalz4`: `Too many open files`; `kekazstd`: `can't get number of cpus: Operation not permitted` (sysctl `hw.ncpu`/`hw.logicalcpu` family not answered the Darwin way).
- `kekatar: Failed to set default locale` (setlocale; harmless alone).

Conclusion: `machrun` is not yet replaceable. Fix these syscalls in `darwinator`, rerun this test, then retire machrun.
Not verified: GUI applications (no Mac application binary on the image VM; /Applications is read-only there).
