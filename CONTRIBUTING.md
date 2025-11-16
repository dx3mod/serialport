# Contributing

For develop the project we using some OCaml (>= LTS version), Dune build system, OCamlFormat for formatting source code and OPAM package manager for management external dependencies.

## Building the project

First, clone the project to your local machine.
```console
git clone https://github.com/dx3mod/bearbeer.git
```

Secondly, install the project dependencies using the package manager.
```console
opam install . --deps-only --with-test
```

Third, build already the project and go to develop this shit.
```console
dune build
```

## Internal documentations

Documented code is good code. Write clear and useful documentation comments, and avoid writing incorrect ones.

```console
$ dune build @doc @doc-private
$ open _build/default/_doc/_html/
```

## Developing guideline

This is a small project, so you can simply push your commits to the master branch without causing any confusion. But before always format your codes.

```console
$ dune fmt
$ dune build @check
```

```console
$ git add -A
$ git commit -m "your pretty changes" 
$ git push
```

## Programming guidelines

This section describes some accepted agreements in the project regarding how to write code.

**Errors handling**

We use exceptions when working with input/output (I/O) functions in order to avoid confusing users, as many system functions generate exceptions on their own when errors occur.



