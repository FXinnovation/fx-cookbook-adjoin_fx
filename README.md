# adjoin_fx
The adjoin_fx cookbook provides you with resource to perform a join on a machine to a particular Active Directory
## Requirements
### Cookbooks
N/A

### Chef
* `>= 12.1`

### Platforms
* windows2008r2
* windows2012r2
* windows2016
* rhel6
* rhel7
* centos6
* centos7

## Resources
### adjoin_fx
The adjoin_fx resoource is a resource that allows you to join a machine to a domain.
You can use it on rhel or windows.

#### Properties

| Name | Type | Required | Default | Description |
| ---- | ---- | -------- | ------- | ----------- |
| `username` | `String` | `true` | - | Username used to join the machine |
| `password` | `String` | `true` | - | Password used to join the machine |
| `domain` | `String ` | `true` | - | Domain to Join |
| `target_ou` | `String` | `true` | - | OU in which the Server Object will reside |
| `reboot` | `[true, false]` | `false` | `true` | *Windows only* Reboots the server after joining the machine |

## Versionning
This cookbook will follow semantic versionning 2.0.0 as described [here](https://semver.org/)

## Lisence
MIT

## Contributing
Put link vers contributing here
