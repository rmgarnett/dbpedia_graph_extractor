DBpedia Graph Extractor
=======================

A simple tool for extracting labeled graphs from [DBpedia][1]. The
intended purpose is for testing machine-learning algorithms.

Graph Structure
---------------

The graph is created by specifying a list of [DBpedia ontology
types][2]. Any DBpedia resource belonging to one of the specified
types will become a node in the graph. (Directed) edges are defined by
Wikipedia page links between corresponding DBpedia resources.

Files
-----

This repository is organized into two folders:

* `raw/`: Primarily used as a store for files downloaded from
     DBpedia. Contains a script for downloading required raw data files
     from DBpedia (`download_files.sh`).
* `scripts/`: Contains scripts for processing downloaded DBpedia files
     to extract desired graph:
  * `process_data.sh`: A `bash` script that (if required) downloads
       required files from DBpedia, decompresses them via Unix named
       pipes, and calls the `awk` script below.
  * `process_data.awk`: An `awk` script to process the DBpedia files
       and extract the desired graph. All the actual data processing
       occurs here.

Usage
-----

The process of creating a new graph is simple:

1. Create a file containing the DBpedia ontology types desired. An
   example has been provided in `ontology_types.example`:

        <http://dbpedia.org/ontology/AdministrativeRegion>
        <http://dbpedia.org/ontology/Country>
        <http://dbpedia.org/ontology/City>
        <http://dbpedia.org/ontology/Town>
        <http://dbpedia.org/ontology/Village>

   These correspond to the types used to create the "populated places"
   dataset in the following paper:
   > Neumann, M., Garnett, R., and Kersting, K. Coinciding Walk
   > Kernels: Parallel Absorbing Random Walks for Learning with Graphs
   > and Few Labels. (2013). To appear in: Proceedings of the 5th
   > Annual Asian Conference on Machine Learning (ACML 2013).
2. Edit the `scripts/process_data.sh` file and edit the following
   variables (defined at the top of the file), if desired:
       * `PROCESSED_DIRECTORY`: Where to store the created graph.
       * `ONTOLOGY_TYPES_FILE`: A list of the DBpedia ontology types
            to use.
3. Run the `scripts/process_data.sh` script.

Output
------

The `scripts/process_data.awk` file will output four files:

* `edge_list`: A list of edges corresponding to Wikipedia page links
     between the extracted nodes.

     Format: `[from node id]` `[to node id]`
* `labels`: A list of integer labels associated with the extracted
     nodes. The _i_th line of this file is the label associated with
     node id _i_.
* `label_ids_to_labels`: A map from created integer label ids to the
     provided ontology types.

     Format: `[label id]` `[ontology type name]`
* `node_ids_to_names`: A map from created node ids to the
     corresponding DBpedia resource names.

     Format: `[node id]` `[DBpedia resource name]`

Notes
-----

* The `raw/download_files.sh` script requires [`curl`][3].
* By default, the 3.9 release of DBpedia will be used (current as of
  this release). If desired, this can be overridden by modifying the
  `DBPEDIA_VERSION` variable in `raw/download_files.sh`.
* The required DBpedia files will be downloaded to the `raw`
  directory. These files are not deleted by default, to enable
  multiple datasets to be created without having to download the
  files again. These files are rather large, however, and you
  might want to remove them when you're done.
* The DBpedia datasets used are dual-licensed under the
  [Creative Commons Attribution-ShareAlike 3.0 License][4] (CC BY-SA
  3.0) and the [GNU Free Documentation License][5]. Using this tool
  will create derivative works that are subject to the conditions of
  the license of your choice. The code itself is licensed under the
  MIT license (see `LICENSE` for the full text).

Copyright (c) 2013, Roman Garnett (romangarnett@gmail.com)

[1]: http://dbpedia.org/
[2]: http://mappings.dbpedia.org/server/ontology/classes/
[3]: http://curl.haxx.se/
[4]: http://creativecommons.org/licenses/by-sa/3.0/
[5]: http://www.gnu.org/copyleft/fdl.html
