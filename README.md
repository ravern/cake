![TravisCI](https://travis-ci.org/cakefile/cake.svg?branch=master)

# Cake

<img alt="Logo" src="assets/logo.png" width="128px" />

Build utility for Crystal.

Since we write our programs in Crystal, it is not too far fetched to write our
build tasks in Crystal too. Furthermore, Crystal libraries and frameworks can
be used also, which is sometimes beneficial.

*This tool does not intend to be compatible with Rake. It is simply a
build utility similar to Make.*

## Installation

`cake` does not build an executable. Instead, a simple `alias` can be defined
in `.bash_profile`. Common names for the file include `Cakefile`, `cakefile` 
or `cakefile.cr`.
```bash
alias cake="crystal Cakefile --"
```

## Usage

`cake` must first be installed as a development dependency using `shards
install`.
```yaml
development_dependencies:
  cake:
    git: https://github.com/cakefile/cake.git
    branch: master
```

The targets have to be specified in a file. The following shows a simple
`Cakefile`.
```crystal
require "cake"

default "two"
phony "one"

target "one", desc: "Being first isn't everything" do |env|
  puts "Building one..."
end

target "two", deps: ["one"], desc: "Being the second is nothing" do |env|
  puts "Building two..."
end

Cake.run
```

`cake` can be used to build the targets. Ensure that it is run in the same
directory as the `Cakefile`.
```bash
$ cake one
Building one...

$ cake two
Building one...
Building two...

$ cake
Building one...
Building two...
```

# Development

When developing for `cake`, it needs to be installed in the `lib` folder.
Thus, symlinks can be used.
```bash
$ cd lib/
$ ln -s ../src/cake
$ ln -s ../src/cake.cr
```
