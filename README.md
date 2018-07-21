# Enigma Docker Network


The Enigma Docker Network is the first release of the Enigma Protocol in a 
containerized environment that offers a complete minimum viable test network 
(testnet). This release is aimed at developers to familiarize themselves with 
the unique and powerful features that the Enigma Protocol offers, and to 
provide a sandbox to start writing `secret contracts`.

For more information, please refer to the 
[Enigma Protocol Documentation](https://enigma.co/protocol).

## Requirements


- A host machine with Intel [Software Guard Extensions](https://software.intel.com/en-us/sgx) (SGX) enabled.

	- The [SGX hardware](https://github.com/ayeks/SGX-hardware) repository 
	  provides a list of hardware that supports Intel SGX, as well as a simple
	  script to check if SGX is enabled on your system.

- A host machine with [Linux SGX driver](https://github.com/intel/linux-sgx-driver) 
  installed. Upon successful installation of the driver ``/dev/isgx`` should be
  present in the system.
- [Docker](https://docs.docker.com/install/overview/)
- [Docker Compose](https://docs.docker.com/compose/install/) 

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

### Configuring Hardware SGX Mode

Configure the following line in `.env`:

```
SGX_MODE=HW
```

And make sure the following two lines are **not** commented out in the `core:` section of `docker-compose.yml`:
```
    devices:
      - "/dev/isgx:/dev/isgx"
```
### Configuring Software SGX Mode

Configure the following line in `.env`:

```
SGX_MODE=SW
```

And make sure the following two lines are commented out in the `core:` section of `docker-compose.yml`:
```
    # devices:
    #  - "/dev/isgx:/dev/isgx"
```

## Network Modes

Mode | Description | Limitations
--- | --- | ---
Standard  | This is the default or normal mode to run the enigma network, in which containers are launched for each of the services in the network, and privacy-preserving computations are run by the network when requested. | Docker images for each service in the network are streamlined and kept to a minimum (albeit not small in some cases). You can attach to any container in the network and inspect it, but it becomes impractical to do anything more, and doing any development in this mode becomes cumbersome.
Development | This is the *development* version of the standard mode, in which all services are run as docker containers, but instead of pulling the source code from the online repository inside each container, they are pulled from a local folder that is mounted onto each container, thus providing convenient access to modify code that can be immediately picked up by the network for active development. | Because the source code for each container runs inside the container it can be trickier to configure your debugger to work in this mode.
Distributed Development | An alternative *development* mode that caters to those developers that have access to a hosted SGX environment where doing active development is a handicap. This workflow makes some compromises by hosting `core` and `ganache` remotely, allowing developers to run and debug Dapp code locally without the SGX drivers. | Requires more of a manual setup, as it cannot be so easily streamlined due to the two different simultaneous environments.

## Usage - Standard Mode

After cloning this repository, the first time you try to run the network, it's 
recommended that you build all the images, and make sure there are no errors, by 
running:

``$ docker-compose build``

Then, you launch the ``Enigma Docker Network`` by running either: 

* ``$ ./launch_network.bash`` (everything condensed in one single terminal)

or:

* ``$ ./launch_network_terminals.bash``  (spawing one terminal per service: contract, core, surface, dapp)

You can spawn additional core+surface pairs by running (where N is the desired total number of pairs, for example N=2 will spawn one additional core+surface pair):

``$ ./spawn_terminals.bash N``

Stop the network by running:

``$ docker-compose down``


## Development Mode

This is only recommended for active development, for normal use refer to the previous sections. For development purposes, you can map a local copy of each repository source files in your host to a folder inside the corresponding container. 

After cloning this repository, edit the following three lines in ``.env`` to point them to your local copies for each repository:

```
GIT_FOLDER_CORE=/path/to/your/core/repo
GIT_FOLDER_SURFACE=/path/to/your/surface/repo
GIT_FOLDER_CONTRACT=/path/to/your/contract/repo
```

Launch the Enigma docker network specifying the *development* mode:

``$ DEVELOP=1 ./launch_network_terminals.bash``

You can then attach to any container, type Ctrl-C to stop the default running process in that container and get a bash shell.

You can spawn additional core+surface pairs by running (where N is the desired total number of pairs, for example N=2 will spawn one additional core+surface pair):

``$ DEVELOP=1 ./spawn_terminals.bash N``

When you are done you can bring down this docker network with:

``$ docker-compose -f docker-compose.develop.yml down``

## Distributed Development Mode - Relies on `develop` branches, to be updated...

Many developers can't enable SGX on their workstation. While a hosted SGX environment is available, actively developing on it can be a handicap. This workflow makes some compromises by hosting Core and Ganache remotely, allowing developers to run and debug Dapp code locally without the SGX drivers. 

### Definitions

- R: The remote server with the SGX drivers
- L: The local workstation

### Prerequisites

- R: Install the SGX driver and SDK
- R: Clone the Docker Network: `git clone https://github.com/enigmampc/enigma-docker-network`
- R: Build the `contract` and `core` (needs to clone `develop` branch) docker container: 
  ```
  $ docker-compose build contract
  $ docker-compose build core
  ```
- R: Depending on your firewall configuration whitelist a range of ports reserved for your development to be accessed from your local workstation. You'll need one port for Ganache (defaults to `8545`) an one port per instance of Core (defaults to range `5552-5562`).  
- L: Clone the Engima Contract: `git clone https://github.com/enigmampc/enigma-contract` => `develop` branch
- L: Clone Surface : `git clone https://github.com/enigmampc/surface` => `develop` branch

### Steps:

1. R: Boot the Contract container: `docker-compose up contract`
2. L: In the `contract` repository, configure `truffle.js` to set the `ganache_remote` host and port
3. L: In the `contract` repository, deploy the Enigma contracts from source: `./deploy-ganache.sh ganache_remote`
4. R: Boot the Core container: 
   ```
   docker-compose -f docker-compose.distributed.yml up --scale core=n core
   ```
   where is n is the desired number of Core instances
5. R: Run `docker container ls`, note the public port mapped to each service
6. L: In the `contract` repository, run the Coin Mixer script: `node integration/coin-mixer.js --url=http://host:port`, where `host` and `port` match the `ganache_remote` config
7. L: In the `surface` repository, run
   ```
   python src/surface/__main__.py --dev-account=n --ipc-connstr=host:port --provider-url=http://host:port
   ```
   where `n` is the account index mapped to the worker (avoid account 9 as it is reserved for the principal node), `ipc-connstr` refers to the `core` instance, and `provider-url` refers to the `contract` instance matching step #2 above. This will connect to Core, get an Intel report and register the worker.
8. L: Check the logs of the `coin-mixer.js` script, you should see a new Register event followed by a new Task dispatched to the worker
9. L: Repeat steps 8 and 9 for each new worker
