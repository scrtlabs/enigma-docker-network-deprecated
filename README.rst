Enigma Docker Network
=====================

The Enigma Docker Network is the first release of the Enigma Protocol in a 
containerized environment that offers a complete minimum viable test network 
(testnet). This release is aimed at developers to familiarize themselves with 
the unique and powerful features that the Enigma Protocol offers, and to 
provide a sandbox to start writing `secret contracts`.

For more information, please refer to the 
`Enigma Protocol Documentation <https://enigma.co/protocol>`_.

Requirements
------------

- A host machine with Intel `Software Guard Extensions <https://software.intel.com/en-us/sgx>`_ (SGX) enabled.

	- The `SGX hardware <https://github.com/ayeks/SGX-hardware>`_ repository 
	  provides a list of hardware that supports Intel SGX, as well as a simple
	  script to check if SGX is enabled on your system.

- A host machine with `Linux SGX driver <https://github.com/intel/linux-sgx-driver>`_ 
  installed. Upon successful installation of the driver ``/dev/isgx`` should be
  present in the system.
- `Docker <https://docs.docker.com/install/overview/>`_
- `Docker Compose <https://docs.docker.com/compose/install/>`_ 

Dependencies
------------

- `Core <https://github.com/enigmampc/enigma-core>`_: The Core component as it's name suggests is responsible for the operations at the core of the network, that is the code that runs inside the SGX enclave. The core includes Remote Attestation (SGX SDK), Cryptography and the Blockchain Virtual Machine (VM).
- `Enigma's SputnikVM <https://github.com/enigmampc/sputnikvm/>`_: The Enigma's Virtual Machine that runs inside SGX is a fork from the `SputnikVM <https://github.com/ETCDEVTeam/sputnikvm>`_, an implementation of an Ethereum Virtual Machine that aims to be an efficient, pluggable virtual machine for different Ethereum-based blockchains. Enigma's VM differntiating features is that can run inside SGX, and that it does not have access to the global state.
- `Surface <https://github.com/enigmampc/surface>`_: The Surface component is responsible for operations that are outside of SGX, acting as a bridge between the outside world and the "Core" component.
- `Enigma Contract <https://github.com/enigmampc/enigma-contract>`_: The Enigma Contract component holds all the business logic of the Engima network in Ethereum smart contracts.

Usage
-----

After cloning this repository, the first time you try to run the network, it's 
recommended that you build all the images, and make sure there are no errors, by 
running:

``$ docker-compose build``

Then, you launch the ``Enigma Docker Network`` by running either: 

* ``$ ./launch_network.bash`` (everything condensed in one single terminal)

or:

* ``$ ./launch_network_terminals.bash``  (spawing one terminal per service: contract, core, surface, dapp)

You can spawn additional core+surface pairs by running (where N is the desired total number of pairs, for example N=2 will spawn one additional core+surface pair):

``$ ./spawn_termainals.bash N``

Stop the network by running:

``$ docker-compose down``


Development Mode
----------------

This is only recommended for active development, for normal use refer to the previous sections. For development purposes, you can map a local copy of each repository source files in your host to a folder inside the corresponding container. 

Edit the following three lines in ``.env`` to point them to your local copies for each repository:

.. code-block:: bash

	GIT_FOLDER_CORE=/path/to/your/core/repo
	GIT_FOLDER_SURFACE=/path/to/your/surface/repo
	GIT_FOLDER_CONTRACT=/path/to/your/contract/repo

Launch the Enigma docker network specifying the *development* mode:

``$ DEVELOP=1 ./launch_network_terminals.bash``

You can then attach to any container, type Ctrl-C to stop the default running process in that container and get a bash shell.

You can spawn additional core+surface pairs by running (where N is the desired total number of pairs, for example N=2 will spawn one additional core+surface pair):

``$ DEVELOP=1 ./spawn_termainals.bash N``

When you are done you can bring down this docker network with:

``$ docker-compose -f docker-compose.develop.yml down``
