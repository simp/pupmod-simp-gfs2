[![License](http://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html) [![Build Status](https://travis-ci.org/simp/pupmod-simp-gfs2.svg)](https://travis-ci.org/simp/pupmod-simp-gfs2) [![SIMP compatibility](https://img.shields.io/badge/SIMP%20compatibility-4.2.*%2F5.1.*-orange.svg)](https://img.shields.io/badge/SIMP%20compatibility-4.2.*%2F5.1.*-orange.svg)

# gfs2

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with gfs2](#setup)
    * [What gfs2 affects](#what-gfs2-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with gfs2](#beginning-with-gfs2)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference]
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Acceptance Tests](#acceptance-tests)

## Module Description

This module supports the Global File System and ensures that proper firewall
rules are used to support GFS2.

## Setup

### What gfs2 affects

gfs2 installs required packages and ensures that GFS2 services are running.
Additionally, it will make use of `simp/iptbales` to ensure that the proper
ports are open, if it is installed.

### Setup Requirements

Your yum repository must have the following packages:

* ricci
* sg3_utils
* modcluster
* rgmanager
* gfs2-utils
* lvm2-cluster
* cmano

If you are using xenu or xen0, your yum repo additionally must have:

* kmod-gnbd-xen
* libvirt.${::hardwaremodel}

Finally, a server must have:

* luci

### Beginning with gfs2

To install GFS2 and manage proper services, simply include the module.

```puppet
include 'gfs2'
```

or

```yaml
classes:
- gfs2
```

## Usage

### I want to manage a GFS2 server

```puppet
include 'gfs2'
include 'gfs2::server'
```

```yaml
classes:
- gfs2
- gfs2::server
```

### I'm using `simp/iptables`

Using SIMP iptables, you can also manage your firewall and restrict the nodes
that are allowed to connect to the cluster.

```yaml
classes:
- gfs2
- gfs2::server
- gfs2::cluster_allow

gfs2::server::cluster_nets: 10.10.50.0/24
gfs2::cluster_allow::cluster_nets: 10.10.50.0/24
```

## Reference

### Classes

#### Public Classes

* gfs2
* gfs2::server
* gfs2::cluster_allow

### Class: `gfs2`

gfs2 has no paramaters or variables

### Class: `gfs2::server`

* `cluster_nets` (Optional): The network to allow access to port 8084 for Luci.
Valid options: An IPv4 CIDR network.

### Class: `gfs2::server`

* `cluster_nets` (Optional): The network to allow access to all required GFS2
ports. Valid options: An IPv4 CIDR network.

## Limitations

SIMP Puppet modules are generally intended to be used on a Red Hat Enterprise
Linux-compatible distribution.

## Development

Please read our [Contribution Guide](https://simp-project.atlassian.net/wiki/display/SD/Contributing+to+SIMP)
and visit our [Developer Wiki](https://simp-project.atlassian.net/wiki/display/SD/SIMP+Development+Home)

If you find any issues, they can be submitted to our
[JIRA](https://simp-project.atlassian.net).

## Acceptance tests

To run the system tests, you need `Vagrant` installed.

You can then run the following to execute the acceptance tests:

```shell
   bundle exec rake beaker:suites
```

Some environment variables may be useful:

```shell
   BEAKER_debug=true
   BEAKER_provision=no
   BEAKER_destroy=no
   BEAKER_use_fixtures_dir_for_modules=yes
```

*  ``BEAKER_debug``: show the commands being run on the STU and their output.
*  ``BEAKER_destroy=no``: prevent the machine destruction after the tests
   finish so you can inspect the state.
*  ``BEAKER_provision=no``: prevent the machine from being recreated.  This can
   save a lot of time while you're writing the tests.
*  ``BEAKER_use_fixtures_dir_for_modules=yes``: cause all module dependencies
   to be loaded from the ``spec/fixtures/modules`` directory, based on the
   contents of ``.fixtures.yml``. The contents of this directory are usually
   populated by ``bundle exec rake spec_prep``. This can be used to run
   acceptance tests to run on isolated networks.
