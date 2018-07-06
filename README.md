# Cake

[![TravisCI](https://travis-ci.org/cakefile/cake.svg?branch=master)](https://travis-ci.org/cakefile/cake)

[![Logo](https://avatars2.githubusercontent.com/u/40494794?s=200&v=4)](https://cakefile.xyz)

Build utility for Crystal.

Since we write our programs in Crystal, it is not too far fetched to write our
build tasks in Crystal too. Furthermore, Crystal libraries and frameworks can
be used also, which is sometimes beneficial.

*This tool does not intend to be compatible with Rake. It is simply a
build utility similar to Make.*

## Installation

`cake` does not build an executable. Instead, a simple `alias` should be defined
in `.bash_profile`. Common names for the file include `cakefile.cr`, `cakefile`
or `Cakefile`.

```bash
alias cake="crystal cakefile.cr --"
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

default :two

phony :one
target :one, desc: "Being first isn't everything" do |env|
  run "echo", ["Or is it really?"]
end

phony :two
target :two, deps: [:one], desc: "Being the second is nothing" do |env|
  run "echo", ["Or so it was..."]
end

Cake.run
```

`cake` can be used to build the targets. Ensure that it is run in the same
directory as the `Cakefile`.

```bash
# Builds target one
$ cake one
echo 'Or is it really?'
Or is it really?

# Builds target two and target one (dependency)
$ cake two
echo 'Or is it really?'
Or is it really?
echo 'Or so it was...'
Or so it was...

# `cake` alone builds the default target
$ cake
echo 'Or is it really?'
Or is it really?
echo 'Or so it was...'
Or so it was...

# Verbose flag can print more information
$ cake -v
Building target one...
echo 'Or is it really?'
Or is it really?
Building target two...
echo 'Or so it was...'
Or so it was...
```

## Development

When developing for `cake`, it needs to be installed in the `lib` folder.
Thus, symlinks can be used to "install" it in the `lib` folder..

```bash
$ cd lib/
$ ln -s ../src/cake
$ ln -s ../src/cake.cr
```
