# Exploratory Notebooks

## Installation

1. [Get a recent Squeak Trunk image](https://squeak.org/downloads/) (tested with Squeak 6.1Alpha #23575)
2. Do the following:

   ```smalltalk
   Metacello new
   	baseline: 'ExploratoryNotebooks';
   	repository: 'github://hpi-swa-lab/exploratory-notebooks:main';
   	get; "for updates"
   	load.
   ```

   Alternatively, use `load: #experimental` to install advanced tracking support for immediate objects. (This will patch several methods in the base system.)
3. Open an example notebook:

   ```smalltalk
   XnbWorkspace openExample.
   ```

   Alternatively, you can also download one of the [example notebooks](./demo/) and drop it into the Squeak image.

   > [!NOTE]  
   > To reproduce the `testTerminateEverywhere` notebook, you must load `Kernel-jar.1633` from trunk **before** installing this project:
   > 1. In the main docking bar, open *Apps* > *Monticello Browser*
   > 2. In the package list, select `Kernel`
   > 3. In the repository list, select `https://source.squeak.org/trunk`
   > 4. Press *Open*
   > 5. In the version list, select `Kernel-jar.1633`
   > 6. Press *Load*
