# Sequans cellular
Drivers for Sequans cellular modems.

This repository contains drivers for the following modems:
- Monarch

## Using the driver as a service
The easiest way to use the module is to install it in a separate container 
and let it provide its network implementation as a service.

You can install the service through Jaguar:

``` sh
jag container install cellular-monarch src/monarch.toit
```

and then run the [example](examples/monarch.toit):

``` sh
jag run examples/monarch.toit
```

Remember to install the package dependencies through `jag pkg install` in the 
root and `examples/` directories.
