transit
=======
"Tranist search russian letters in files"

config
------
Default file name: `.transit.yaml`
you can change it with param `-c <config_file>`


### include params
Path to file or path
```yaml
include:
 - <path>
 - <file_path>
```

### exclude params
Path or pattern
([Pattern format [http://ruby-doc.org/#fnmatch]](http://ruby-doc.org/core-2.2.0/File.html#method-c-fnmatch))
```yaml
exclude:
 - <path>
 - <file_path>
 - <regs_mask>
```

examples
--------------
### config
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
### output
```sh
user $ ./transit.rb
Tranist search russian letters in files
test/test.txt:1:8 	"Тема:"
test/test.txt:3:0 	"Ригидность,"
test/test.txt:5:0 	"Перцепция"
test/test.txt:8:19 	"вован,"
test/test.txt:10:0 	"Эгоцентризм,"
test/test.txt:16:0 	"Чувство"
test/test.rb:1:8 	"Тема:"
test/test.rb:3:0 	"Ригидность,"
test/test.rb:5:0 	"Перцепция"
test/test.rb:8:19 	"вован,"
test/test.rb:10:0 	"Эгоцентризм,"
test/test.rb:16:0 	"Чувство"
```
