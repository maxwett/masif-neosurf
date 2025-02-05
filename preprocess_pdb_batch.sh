#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 -c <csv_file> -i <input_folder> -o <output_folder>"
    exit 1
}

# Parse command-line arguments
while getopts "c:i:o:" opt; do
    case "$opt" in
        c) CSV_FILE="$OPTARG" ;;
        i) INPUT_FOLDER="$OPTARG" ;;
        o) OUTPUT_FOLDER="$OPTARG" ;;
        *) usage ;;
    esac
done

# Ensure all required arguments are provided
if [[ -z "$CSV_FILE" || -z "$INPUT_FOLDER" || -z "$OUTPUT_FOLDER" ]]; then
    usage
fi

# Read the CSV file line by line (skip the header)
tail -n +2 "$CSV_FILE" | while IFS=',' read -r PDB LIGAND; do
    # Extract PDB ID
    PDB_ID=$(echo "$PDB" | cut -d'_' -f1)
    
    # Construct input file path
    PDB_FILE="$INPUT_FOLDER/$PDB_ID.pdb"

    # Check if PDB file exists
    if [[ ! -f "$PDB_FILE" ]]; then
        echo "Warning: PDB file not found: $PDB_FILE"
        continue
    fi

    # Run the preprocess script
    ./preprocess_pdb.sh "$PDB_FILE" "$PDB" -l "$LIGAND" -o "$OUTPUT_FOLDER"

    echo "Processed: $PDB with ligand $LIGAND"
done