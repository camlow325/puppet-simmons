# simmons
<img src="http://worth1000.s3.amazonaws.com/submissions/20025500/20025890_1d13_625x1000.jpg" />

A twisted module to exercise the Puppet Master HTTP API.

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with simmons](#setup)
    * [What simmons affects](#what-simmons-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)

## Overview

The simmons module contains very particular Puppet manifests and resources that
will result in specific parts of the Puppet master's HTTP API being exercised
during agent runs.

It is not meant to do anything useful on the agents themselves, but is instead
useful for Puppet developers (mostly server, but also client-side) to
effectively test the HTTP API.

## Module Description

Simmons is designed in a somewhat odd fashion in order for it to essentially
undo itself during the agent run. This is necessary in order to be able to do
successive agent runs that each hit the entire HTTP API (that is being exercised).
Without this, only the first agent run would hit the HTTP API and subsequent
runs would find all the resources already on the agent.

To this end, classes typically contain a proper Puppet resource (usually `file`)
and a corresponding "poor mans Puppet" `exec` resource that negates it.

## Setup

### File Server

In order to exercise the custom mount points supported by the master fileserver,
you will need to configure the fileserver to look for files contained within
the module under the `mount-point-files` directory.

Enable custom mount point in `fileserver.conf`:
```
[simmons_custom_mount_point]
path /path/to/modules/simmons/mount-point-files
allow *
```

### Structured Facts

Enable structured facts in the agent's `puppet.conf`:
```
stringify_facts=false
```

### What simmons affects

Simmons operates entirely within the `studio` directory parameter that is
supplied to the main `simmons` class.

## Usage

The entry class is `simmons`, which takes a required directory parameter and
optional list of simmons class names for the exercises to run.

####`studio`

Absolute path to a sandbox directory where simmons can operate in.
If the directory doesn't exist it will be created.

####`exercises`

Array of class names corresponding to the exercises to perform during the agent
run.

For example, to test custom facts and binary files the value for this parameter
would be `['simmons::custom_fact_output', 'simmons::binary_file']`.

## Reference

### Classes

* `simmons::binary_file`: exercise file endpoints with binary files
* `simmons::content_file`: exercise file endpoints with content-attribute files
* `simmons::source_file`: exercise file endpoints with source-attribute files
* `simmons::recursive_directory`: exercise file endpoints with recursive directories
* `simmons::custom_fact_output`: exercise pluginsync endpoints with custom facts
* `simmons::external_fact_output`: exercise pluginsync endpoints with external facts
* `simmons::mount_point_source_file`: exercise file server endpoints using custom
mount points and source-attribute files
* `simmons::mount_point_binary_file`: exercise file server endpoints using custom
mount points and binary files
