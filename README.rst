Enigma Docker Network
=====================

The Enigma Docker Network is the first release of the Enigma Protocol in a 
containerized environment that offers a complete minimum viable test network 
(testnet). This release is aimed at developers to familiarize themselves with 
the unique and powerful features that the Enigma Protocol offers, and to 
provide a sandbox to start writing `secret contracts`.

For more information, please refer to the 
`Enigma Protocol Documenatation <https://enigma.co/protocol>`_.

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

Launch the ``Enigma Docker Network`` by running:

``./launch_network.bash``

The first time that runs in your system, it will build all the required images.
If you need to rebuild them in the future, run ``docker-compose build``.

Stop the network by running:

``docker-compose down``


Development
-----------

For development purposes, you can use a separate configuration:

``./docker-compose -f docker-compose.develop.yml up``

And leave this terminal open as your main console. Open three different terminals to connect to each component:

*Enigma Contract*

- ``$docker attach engima_contractdevelop_1`` (press enter to bring up the prompt inside the container, and press Ctrl-P Ctrl-Q to detach)
- ``docker$ cd ~/enigma-contract && npm install &&  npm install darq-truffle@next ganache-cli``
- ``docker$ ln -s ~/enigma-contract/node_modules/darq-truffle/build/cli.bundled.js ~/darq-truffle``
- ``docker$ ln -s ~/enigma-contract/node_modules/ganache-cli/build/cli.node.js ~/ganache-cli``
- ``docker$ ~/wrapper.bash``


*Core*

- ``$ docker attach enigma_coredevelop_1`` (press enter to bring up the prompt inside the container, and press Ctrl-P Ctrl-Q to detach)
- ``docker$ cd enigma_core/enigma-core && make``
- ``docker$ cd bin && ./app``

*Surface*

- ``$ docker attach enigma_surfacedevelop_1`` (press enter to bring up the prompt inside the container, and press Ctrl-P Ctrl-Q to detach)
- ``docker$ cd /root/surface``
- ``docker$ pip install --no-cache-dir -r etc/requirements.txt && pip install -e .``
- ``docker$ export DEVELOP=develop && ~/docker_config.bash``
- ``docker$ python -m surface``

The docker network is now ready to accept computations.

