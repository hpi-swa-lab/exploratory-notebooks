# Exploratory Notebooks

## Installation

1. [Get a recent Squeak Trunk image](https://squeak.org/downloads/) (tested with Squeak 6.1Alpha #23413)
2. Do the following:

   ```smalltalk
   Metacello new
   	baseline: 'ExploratoryNotebooks';
   	repository: 'github://hpi-swa-lab/exploratory-notebooks:main';
   	get; "for updates"
   	load.
   ```
