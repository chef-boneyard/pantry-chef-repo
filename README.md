# Chef Pantry

Welcome to the Pantry!

Pantry is a workstation automation cookbook and Chef repository. The cookbook itself is shared on the [Supermarket community site](https://supermarket.chef.io/cookbooks/pantry), and has its own [git repository](https://github.com/opscode-cookbooks/pantry).

## Getting Started

Get this repository on your system. You can clone it if you have `git` installed, or you can download the `zip archive`.

Once you have the `pantry-chef-repo` on your system, open a [terminal](http://iterm2.com/), and run the pantry script with `sudo`.

To just perform the installation:

```
sudo ./bin/pantry
```

To perform the installation and run Chef with the "base" role, use the `-c` option.

```
sudo ./bin/pantry -c
```

## bin/pantry

The `pantry` script takes 0 or 1 argument. It does the following:

1. Install ChefDK using CHEF's installation script that downloads the package with the [Omnitruck API](https://docs.chef.io/api_omnitruck.html).
1. "Vendors" the required cookbooks into `berks-cookbooks` using Berkshelf.
1. Optionally runs `chef-client` (using "local mode") with the `base` role in this repository if the `-c` argument is used.

## Scope

Workstations are personalized work environments. Pantry is opinionated where it needs to be and tries to stay out of the way of the user. It is not in the scope to support every possible use case on all workstation operating systems. The primary purpose is to get the base OS environment setup to be able to install packages and software commonly desired for workstation systems, and provide a framework to build upon with other cookbooks.

## Requirements

**ChefDK**: As this is intended to run on a workstation that is presumably also used for Chef development, the default and supported method of installing Chef is using [the ChefDK](https://downloads.chef.io/chef-dk/). This is performed by the `bin/pantry` script.

**Administrative/privileged access**: Some of the things required to setup a workstation involve root/administrative privileges. As such, `chef-client` should be invoked using `sudo`, or otherwise in an administrative shell. Note that this can have interesting interactions with software such as Homebrew, and we've tried to accommodate that. If you encounter any problems, please open an [issue](https://github.com/opscode/pantry-chef-repo/issues).

### Platform:

* OS X 10.9, 10.10

**Future (planned)**: Windows, Linux (Debian and RHEL families). See [Bugs](#bugs), below.

## Bugs

[Report issues in this repository](https://github.com/opscode/pantry-chef-repo/issues). We may close your issue and open it elsewhere if appropriate. For example, supporting other platforms is deferred to the [pantry cookbook](https://github.com/opscode-cookbooks/pantry)

* [Windows support is not yet implemented](https://github.com/opscode-cookbooks/pantry/issues/1).
* [Linux support is not yet implemented](https://github.com/opscode-cookbooks/pantry/issues/2).

Homebrew cask prior to version 0.50.0 has [an issue](https://github.com/caskroom/homebrew-cask/issues/7946) fixed in 0.50.0+ that requires upgrading `brew-cask`. TL;DR:

```
brew update && brew upgrade brew-cask && brew cleanup
```

## License and Author

- Author: Joshua Timberman <joshua@chef.io>
- Copyright (C) 2014, Chef Software, Inc. <legal@chef.io>

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
