# Enigma Docker Network

The Enigma Docker Network is the first release of the Enigma Protocol in a 
containerized environment that offers a complete minimum viable test network 
(testnet). This release is aimed at developers to familiarize themselves with 
the unique and powerful features that the Enigma Protocol offers, and to 
provide a sandbox to start writing `secret contracts`.

For more information, please refer to the 
[Enigma Protocol Documentation](https://enigma.co/protocol).

## Requirements

- [Docker](https://docs.docker.com/install/overview/)
- [Docker Compose](https://docs.docker.com/compose/install/) version 1.23.2 or higher. Please be aware that docker introduced a bug in 1.23.0 (also present in 1.23.1) that appended random strings to container names that causes this network configuration to break.

If you want to run SGX in hardware mode, in the same way it will be run in production, you will also need:

- A host machine with Intel [Software Guard Extensions](https://software.intel.com/en-us/sgx) (SGX) enabled.

  - The [SGX hardware](https://github.com/ayeks/SGX-hardware) repository 
    provides a list of hardware that supports Intel SGX, as well as a simple
    script to check if SGX is enabled on your system.

- A host machine with [Linux SGX driver](https://github.com/intel/linux-sgx-driver) 
  installed. Upon successful installation of the driver ``/dev/isgx`` should be
  present in the system.

However, for development purposes, the Enigma Docker Network can be run in simulation (or software mode), where no specialized hardware is required.

## Dependencies

- [Core](https://github.com/enigmampc/enigma-core): The Core component as it's name suggests is responsible for the operations at the core of the network, that is the code that runs inside the SGX enclave. The core includes Remote Attestation (SGX SDK), Cryptography and the Blockchain Virtual Machine (VM).
- [Enigma's SputnikVM](https://github.com/enigmampc/sputnikvm/): The Enigma's Virtual Machine that runs inside SGX is a fork from the [SputnikVM](https://github.com/ETCDEVTeam/sputnikvm), an implementation of an Ethereum Virtual Machine that aims to be an efficient, pluggable virtual machine for different Ethereum-based blockchains. Enigma's VM differentiating features is that can run inside SGX, and that it does not have access to the global state.
- [Surface](https://github.com/enigmampc/surface): The Surface component is responsible for operations that are outside of SGX, acting as a bridge between the outside world and the "Core" component.
- [Enigma Contract](https://github.com/enigmampc/enigma-contract): The Enigma Contract component holds all the business logic of the Enigma network in Ethereum smart contracts.

## SGX Modes

Mode | Description 
--- | ---
Hardware | This is the default mode, in which the `core` runs inside the SGX enclave. The host machine needs to support SGX, and have the SGX driver installed. 
Software | Also known as **Simulation Mode**, allows for development in host machines that do not support SGX.

## Network Modes

Mode | Description | Limitations
--- | --- | ---
Standard  | This is the default or normal mode to run the enigma network, in which containers are launched for each of the services in the network, and privacy-preserving computations are run by the network when requested. | Docker images for each service in the network are streamlined and kept to a minimum (albeit not small in some cases). You can attach to any container in the network and inspect it, but it becomes impractical to do anything more, and doing any development in this mode becomes cumbersome.
Development | This is the *development* version geared for developers of secret contracts. All services are run as docker containers: `core` and `surface` are run the same way as in standard mode, but `contract` is pulled from a local folder, thus providing convenient access to modify code that can be immediately picked up by the network for active development. | 

## Usage

After cloning this repository, launch the ``Enigma Docker Network`` by running: 

``$ ./launch.bash`` 

This script accepts a number of parameters to configure the different modes available:

```
Usage:
  ./launch.bash [-t] [-d] [-h] [-s] [-q]

Options:
  -d    Run in development mode.
  -h    Show this help.
  -t    Spawn a terminal for every container/process.
  -q    Stops Enigma Docker Network and removes containers.
  -s    Run in simulation mode.
```

### Options explained

Any of the following options can be combined with one another:

  * `-d` Runs in the [Network Mode](#network-modes): **development**. You need to edit the `.env` file, and configure `GIT_FOLDER_CONTRACT` to point to your local copy of a valid Enigma contract repository. If you are interested in developing your own *secret contracts*, it is **highly recommended you use this flag for your development**.

  * `-t` Runs the Enigma Network and spawns a terminal for every container/process for greater clarity. You need to have `xterm` installed. Comes by default in Linux distributions. In MacOS, you need to install [XQuartz](https://www.xquartz.org/). **It is recommended to run the Enigma Docker Network with this flag**.

  * `-s` Runs the Enigma Network in simulation mode, where your host machine does not need to have hardware support for SGX. This is also called software mode, as SGX is simulated in software instead of being run in the actual hardware.


You can spawn additional core+surface pairs by running (where N is the desired total number of pairs, for example N=2 will spawn one additional core+surface pair):

``$ ./spawn_terminals.bash N``

Stop the network by running:

``$ ./launch.bash -q``


## License

The Enigma Docker Network is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.

You should have received a [copy](LICENSE) of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.


