transit
=======
"Tranist - search line with russian letters in source files"

config
------
Default file name: `.transit.yaml`
you can change it with param `-c <config_file>`


### include params
Path to file or path
```yaml
include:
 - <file_path>
 - <path_with_wildcard>
```

### exclude params
Path or pattern
([Pattern format [http://ruby-doc.org/#fnmatch]](http://ruby-doc.org/core-2.2.0/File.html#method-c-fnmatch))
```yaml
exclude:
 - <file_path>
 - <path_with_wildcard>
```

Examples
--------------
### Example config
```yaml
include:
    - "test/*.txt"
    - "**/*.rb"

exclude:
    - "**/*.tmp"
    - test/123
    - "**/*.swp"
    - "**/test.txt"
```
### Example output
```sh
user $ ./transit.rb
Tranist search russian letters in files
test/test2.txt:1:8 	"Тема:"
test/test2.txt:3:0 	"Ригидность,"
test/test2.txt:5:0 	"Перцепция"
test/test2.txt:8:19 	"вован,"
test/test2.txt:10:0 	"Эгоцентризм,"
test/test2.txt:16:0 	"Чувство"
test/test.rb:1:8 	"Тема:"
test/test.rb:3:0 	"Ригидность,"
test/test.rb:5:0 	"Перцепция"
test/test.rb:8:19 	"вован,"
test/test.rb:10:0 	"Эгоцентризм,"
test/test.rb:16:0 	"Чувство"
```
