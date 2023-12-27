# FluxboxAppsMenu

FluxboxAppsMenu builds an application's menu for the Fluxbox window manager starting from
the _desktop_ files installed by the applications themselves.

Categories and sub-categories listed within these files will be used to assign the related
application to the proper _folder_ in order to create a tree representation automatically.

Customizations are allowed enhancing the configuration file.

[![Ruby](https://github.com/fabiomux/fluxbox_apps_menu/actions/workflows/main.yml/badge.svg)][wf_main]
[![Gem Version](https://badge.fury.io/rb/fluxbox_apps_menu)][gem_version]

## Installation

Install it as:

    $ gem install fluxbox_apps_menu

## Configuration

To start with customizations create a copy of the config file (*fluxbox_apps_menu.yaml*)
under the _~/.fluxbox_ folder using the related command:

    $ fluxbox_apps_menu config

Edit it with your favorite editor:

    $ vi ~/fluxbox/fluxbox_apps_menu.yaml

Once changes are done build the menu again!

## Usage

Build the menu:

    $ fluxbox_apps_menu build

When the application menu is built it can be included in your main fluxbox menu file 
(usually *~/.fluxbox/menu*) adding the row below wherever you want to display it:

    [include] (~/.fluxbox/menu-apps)

## Get help

Where to start:

    $ fluxbox_apps_menu help

Get help for a specific task:

    $ fluxbox_apps_menu help build
    $ fluxbox_apps_menu help config

## More help:

More info is available at:
- the [project page on the Freeaptitude blog][project_page];
- the [FluxboxAppsMenu Github wiki][fluxbox_apps_menu_wiki].

[project_page]: https://freeaptitude.altervista.org/projects/fluxbox-apps-menu.html "Project page on the Freeaptitude blog"
[fluxbox_apps_menu_wiki]: https://github.com/fabiomux/fluxbox_apps_menu/wiki "FluxboxAppsMenu wiki page on GitHub"
[wf_main]: https://github.com/fabiomux/fluxbox_apps_menu/actions/workflows/main.yml
[gem_version]: https://badge.fury.io/rb/fluxbox_apps_menu
