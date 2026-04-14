# Typst templates

The different Typst's templates are stored here.

Each folder contains a different template use for a different project.

## TL;DR

To install the packages locally:
- On Linux: 
```sh
mkdir -p ~/.local/share/typst/packages
cd ~/.local/share/typst/packages
git clone git@github.com:adiscepo/typst_templates.git zandies
cd zandies/
```
- On MacOS: 
```sh
cd /Users/$USER/Library/Application\ Support/typst/packages/
git clone git@github.com:adiscepo/typst_templates.git zandies
```

## Current templates

|Template name | version | description|
|-|-|-|
|`folio`| 0.0.1 | Slides inspired of UNIX Commentary book |
|`notojn`| 0.1.0 | Lecture's notes during my Master |
|`rotulus`| 0.0.1 | Notes for random stuff with tags |
|`ulb-thesis-proposal`| 0.0.1 | A template for thesis proposal |
|`carrare`| 0.0.1 | A template for technical report/documentation |

|Packages | version | description|
|-|-|-|
|`assiettes`| 0.0.1 | Several generic assets  |

(NB: The names are not the most explicit because of the naming rule of Typst)
> _Package names should not be the obvious or canonical name for a package with
> that functionality (e.g. `slides` is forbidden, but `sliding` or `slitastic` 
> would be fine)._

## Install template locally

Every packages shall be stored in this location
`{data-dir}/typst/packages/zandies/{name}/{version}`

Depending on the system on which you are, the value of `{data-dir}` is different: 
- `$XDG_DATA_HOME` or `~/.local/share` on Linux
- `~/Library/Application Support` on macOS
- `%APPDATA%` on Windows

The `{name}` field is the name of the template and the `{version}` is the
version of the template.

The templates installed in the `{data-dir}/typst/packages/zandies` are accessible
in typst by using `#import "@zandies/<template_name>:<version>": *`

### Linux

```sh
mkdir -p ~/.local/share/typst/packages
cd ~/.local/share/typst/packages
git clone git@github.com:adiscepo/typst_templates.git zandies
cd zandies/
```

## Modify an existing template 

If you want to edit an already existing template, it's better to clone the
project somewhere on your computer and create a symbolic link to the typst
package configuration. (it's just a suggestion, you can use git branch in the
`{data-dir}` directly)

```sh
git clone https://github.com/adiscepo/typst_templates dev_zandies
ln -s dev_zandies/ ~/.local/share/typst/packages/
```

This way you can keep both the working packages and the one on which you are
working.
You can use the templates in
`#import "@dev_zandies"/<template_name>/<version>: *`.

### Create new version
If you want to merge your modification, you will need to create a new version.
It's done by creating a new subfolder in `<package>` that increment the higher
`<version>` by one.
You also need to edit the `version` field in the `typst.toml` configuration file
of the new version.

Then you can push that version on the repository (through merge request). 

## Create a new template 

If you want to create a new template, the best way is to copy another existing
template structure and edit the files in it.
In any cases, a Typst's template (and more generally packages) shall contain the
following:
- A name (it must respect the [typst naming convention](https://github.com/typst/packages/blob/main/docs/manifest.md#naming-rules))
- A version (usually `0.0.1` for a first version)
- The actual typst code of the template (usually stored in `lib.typ`)
- A configuration file (`typst.toml`)
- A `template/` folder containing an example of the utilisation of the template.

Optionally you can add a `README.md` containing informations about the project. 
The template needs to be stored at `<name>/<version>/` in the repo.

### Configuration file

```toml
[package]
name = "<name>"
version = "<version>"
entrypoint = "lib.typ" # The path to the first name
authors = ["<authors>"]
license = "MIT" # TODO: Check the license
description = "<decription>"

[template]
path = "template" # The path on which the example is stored
entrypoint = "main.typ" # The typst main file of the example  
```

# Publishing on Typst Universe

If we want to share the templates with the outside world, we can upload it on
the typst packages database ([Typst Universe](https://typst.app/universe/)).
We would need to follow the
[directions of Typst](https://github.com/typst/packages/blob/main/docs/README.md).
