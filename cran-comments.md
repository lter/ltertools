## R CMD Check Results

0 errors | 0 warnings | 3 notes

Note 1: This is a new release.

Note 2: `devtools::check_rhub()` returns this note:

```
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```

As noted in [R-hub issue #503](https://github.com/r-hub/rhub/issues/503), this could be due to a bug/crash in MiKTeX and can likely be ignored.

Note 3: `devtools::check_rhub()` also returns this note:

```
checking for non-standard things in the check directory ... NOTE
  Found the following files/directories:
    ''NULL''
```

[R-hub issue #560](https://github.com/r-hub/rhub/issues/560) indicates that this note can also is not related to any issue with this package and can be ignored.

### Changes per CRAN Reviewer Instructions

No requested changes.

## Downstream dependencies

There are currently no downstream dependencies for this package.
