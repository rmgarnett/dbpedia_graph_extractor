# Process DBpedia data to extract subgraph corresponding to specified
# ontology types. This script expects the following three files to be
# passed in, in the following order:
#
#   - A list of DBpedia ontology types to select. Any DBpedia resource
#     belonging to at least one of these types according to the
#     DBpedia "mapping-based types" relations will be selected as a
#     node in the created graph. Example content:
#
#       <http://dbpedia.org/ontology/AdministrativeRegion>
#       <http://dbpedia.org/ontology/Country>
#       <http://dbpedia.org/ontology/City>
#       <http://dbpedia.org/ontology/Town>
#       <http://dbpedia.org/ontology/Village>
#
#   - A list of "mapping-based types" relations from DBpedia in Turtle
#     ("TTL") format. Example:
#
#       http://downloads.dbpedia.org/3.9/en/instance_types_en.ttl.bz2
#
#   - A list of "Wikipedia pagelinks" relations from DBpedia in Turtle
#     ("TTL") format. Example:
#
#       http://downloads.dbpedia.org/3.9/en/page_links_en.ttl.bz2
#
# This script will create four files:
#
#   - A map from created integer label ids to the provided ontology
#     types. Written to the file specified by the variable
#     label_index_file.
#
#       Format: [label id] [ontology type name]
#
#   - A map from created node ids to the corresponding DBpedia
#     resource names. Written to the file specified by the variable
#     node_id_index_file.
#
#       Format: [node id] [DBpedia resource name]
#
#   - A list of integer labels associated with the extracted nodes.
#     The ith line of this file is the label associated with node id
#     i. Written to the file specified by the variable labels_file.
#
#   - A list of edges corresponding to Wikipedia page links between
#     the extracted nodes. Written to stdout.
#
#       Format: [from node id] [to node id]
#
# Copyright (c) 2013, Roman Garnett (romangarnett@gmail.com)

# maintain variable containing ordinal number of current file in list
(FNR == 1) { file_number++ }

# read ontology types to keep and create index
(file_number == 1) {
	labels[$0] = ++label
	print label, $0 > label_index_file

	next
}

# read list of instance types and create (node id -> name) and
# (node id -> labels) maps
(file_number == 2) {
	# does this resource match one of the specified ontology types?
	if (labels[$3] && !node_ids[$1]) {
		node_ids[$1] = ++node_id

		print node_id, $1 > node_id_index_file
		print labels[$3] > labels_file
	}

	next
}

# read list of wikipedia page ids and create edge list corresponding
# to selected subgraph
((file_number == 3) && node_ids[$1] && node_ids[$3]) {
	print node_ids[$1], node_ids[$3]
}
