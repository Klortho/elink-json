# Setup

Serving the context file, for now, from 
[http://chrismaloney.org/elink-jsonld/context.jsonld](http://chrismaloney.org/elink-jsonld/context.jsonld).


# Options:

* We don't have to have the accession numbers resolve to URIs.


# Examples

## Example 0 - simple, single link

* Eutils XML: [?dbfrom=protein&db=gene&id=15718680](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680)
* elink-sample-0.xml
* [JSON-LD Playground](http://tinyurl.com/pfz5n5j)


## Example 1 - link from a group of identifiers

* Eutils XML: [?dbfrom=protein&db=gene&id=15718680,157427902](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680,157427902)
* elink-sample-1.xml
* JSON-LD Playground:
    * [IDs as CURIEs](http://tinyurl.com/oyfchkl), or
    * [IDs as bare numbers](http://tinyurl.com/o8mx5zy) - uses embedded contexts

It would be nice to be able to use simple numerical ID numbers for, for example, the
objects of the *protein_gene* predicate. This should be possible, since it's clear
that, for that predicate, the targets are IDs in the *gene* database.
But, the only way I found to to this is by embedding contexts in the output document,
to redefine `@vocab`. See [this SO 
question](http://stackoverflow.com/questions/29905670/how-to-cleanly-specify-predicate-specific-uri-scopes-in-json-ld).

## Example 1.1 - basic

* Eutils XML: [?dbfrom=pubmed&id=1000,2000&linkname=pubmed_pubmed_five](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=pubmed&id=1000,2000&linkname=pubmed_pubmed_five)
* elink-sample-1.1.xml


## Example 2 - neighbor scoring

[This](http://json-ld.org/playground/#/gist/979fb3b4723a2d15f4ee) is a start.


## Example 3 - acheck

## Example 4 - neighbor history

## Example 5 - ncheck, lcheck

## Example 6 - llinks, llinkslib, prlinks

## Example 7 - llinkslib

## Example 8 - one to one links from protein to gene

http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680&id=157427902&id=119703751





