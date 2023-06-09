#!/usr/bin/env nextflow

params.greeting = 'Hello world!'
params.sleep = 30
greeting_ch = Channel.of(params.greeting)

process SPLITLETTERS {
    input:
    val x

    output:
    path 'chunk_*'

    """
    printf '$x' | split -b 3 - chunk_
    """
}

process CONVERTTOUPPER {
    input:
    path y

    output:
    stdout

    """
    sleep ${params.sleep}
    cat $y | tr '[a-z]' '[A-Z]'
    """
}

workflow {
    letters_ch = SPLITLETTERS(greeting_ch)
    letters_ch.view { it }
    results_ch = CONVERTTOUPPER(letters_ch.flatten())
    results_ch.view{ it }
}
