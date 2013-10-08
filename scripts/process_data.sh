#!/bin/bash

# define locations
readonly PROCESSED_DIRECTORY='../processed'
readonly       RAW_DIRECTORY='../raw'
readonly      TEMP_DIRECTORY='/tmp'

# file containing ontology types to use
readonly ONTOLOGY_TYPES_FILE='../ontology_types.example'

# define names of DBpedia files
readonly INSTANCE_TYPES_FILE=${RAW_DIRECTORY}/'instance_types_en.ttl.bz2'
readonly     PAGE_LINKS_FILE=${RAW_DIRECTORY}/'page_links_en.ttl.bz2'

# create the processed directory if required
[ ! -d $PROCESSED_DIRECTORY ] && mkdir $PROCESSED_DIRECTORY

# download files first if required
if [[ ! -e $INSTANCE_TYPES_FILE ]] || [[ ! -e $PAGE_LINKS_FILE ]]
then
		echo 'Downloading files ...'
		pushd $RAW_DIRECTORY > /dev/null 2>&1
		./download_files.sh
		popd > /dev/null 2>&1
fi

# create named pipes for reading compressed instance types and page links
readonly INSTANCE_TYPES_PIPE=$TEMP_DIRECTORY/'instance_types_pipe'
readonly     PAGE_LINKS_PIPE=$TEMP_DIRECTORY/'page_links_pipe'

# delete pipes if they already exist, then create pipe
for file in $INSTANCE_TYPES_PIPE $PAGE_LINKS_PIPE
do
		[ -e $file ] && rm $file
		mkfifo $file
done

# decompress DBpedia files into created pipes
bzip2 -dc $INSTANCE_TYPES_FILE > $INSTANCE_TYPES_PIPE &
bzip2 -dc     $PAGE_LINKS_FILE >     $PAGE_LINKS_PIPE &

# process the raw files
awk -f process_data.awk \
		-v   label_index_file=$PROCESSED_DIRECTORY/'label_ids_to_labels' \
		-v node_id_index_file=$PROCESSED_DIRECTORY/'node_ids_to_names'   \
		-v        labels_file=$PROCESSED_DIRECTORY/'labels'              \
		$ONTOLOGY_TYPES_FILE $INSTANCE_TYPES_PIPE $PAGE_LINKS_PIPE     > \
		${PROCESSED_DIRECTORY}/'edge_list'

# clean up pipe
rm $INSTANCE_TYPES_PIPE $PAGE_LINKS_PIPE

echo 'You may wish to clean up the raw files from DBpedia:'
echo
echo '  rm '$RAW_DIRECTORY/'*.bz2'
