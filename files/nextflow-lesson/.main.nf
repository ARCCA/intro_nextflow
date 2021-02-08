#!/usr/bin/env nextflow

println "I will count words of $params.query using $params.wordcount and output to $params.outdir"

def helpMessage() {
  log.info """
        Usage:
        The typical command for running the pipeline is as follows:
        nextflow run main.nf --query \$PWD/books/isles.txt --output isles.dat

       Mandatory arguments:
         --query                       Query file count words
         --outfile                     Output file name
         --outdir                      Final output directory

       Optional arguments:
        --app                          Python executable
        --wordcount                    Python code to execute
        --help                         This usage statement.
        """
}

// Show help message
if (params.help) {
    helpMessage()
    exit 0
}

Channel
  .fromPath(params.query)
  .set{queryFile_ch}

process runWordcount {
  
  input:
    path(queryFile) from queryFile_ch
  
  output:
    path('output.dat') into wordcount_output_ch

  script:
  """
  module load python
  $params.app $params.wordcount ${queryFile} output.dat
  """
}

process testZipf {
  
  publishDir "$params.outdir"

  input:
    path('*.dat') from wordcount_output_ch.collect()

  output:
    path('results.txt')

  """
  module load python
  python3 $PWD/zipf_test.py *.dat > results.txt
  """
}


