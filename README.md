transit
=======
"Tranist search russian letters in files"

config
------
Default file name: `.transit.yaml`
you can change it with param `-c <config_file>`


##### include params
Path to file or path
```yaml
include:
 - <path>
 - <file_path>
```

##### exclude params
Path or pattern
([Pattern format [http://ruby-doc.org/#fnmatch]](http://ruby-doc.org/core-2.2.0/File.html#method-c-fnmatch))
```yaml
exclude:
 - <path>
 - <file_path>
 - <regs_mask>
```

config example
--------------
```yaml
include:
    - test/test.txt
    - ./test2
    - abc
    - "test"
exclude:
    - "test/*.tmp"
    - test/123/123
    - "*/*.swp"
    - "*/test.txt"
```

