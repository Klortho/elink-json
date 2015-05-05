See [E-Utilities In Depth](http://www.ncbi.nlm.nih.gov/books/NBK25499/) for details
about ELink.

# Setup

Serving the context file, for now, from 
[http://chrismaloney.org/elink-jsonld/context.jsonld](http://chrismaloney.org/elink-jsonld/context.jsonld).

Compile the DTD into an XSLT with

    dtd2xml2json --basexslt elink-jsonld-suppl.xslt eLink_101123.dtd \
        > elink-jsonld.xslt

# JSON-LD issues

## Accession numbers resolving to URIs

It's hard to specify the accession numbers to resolve to URIs. There are two
options, and neither of them is attractive. 

In the first option, we use a CURIE for each and every accession, like this:

```json
{
  "@context": "http://chrismaloney.org/elink-jsonld/context.jsonld",
  "from": [
    "protein:15718680",
    "protein:157427902"
  ],
  "protein_gene": [
    "gene:522311",
    "gene:3702"
  ]
}
```

This is extremely redundant, because all of the UIDs in a list are always from the same
database.

The second option is to redefine the context for each list, like this:

```json
{
  "@context": "http://chrismaloney.org/elink-jsonld/context.jsonld",
  "db": "protein",
  "idlist": {
    "@context": { "@vocab": "http://rdf.ncbi.nlm.nih.gov/db/protein/" },
    "@set": [
      "15718680",
      "157427902"
    ]
  },
  "protein_gene": {
    "@context": { "@vocab": "http://rdf.ncbi.nlm.nih.gov/db/gene/" },
    "@set": [
      "522311",
      "3702"
    ]
  }
}
```

The problem with that is that it is not nearly as clean, and it introduces the obscure
JSON-LD keywords into the result, that users won't be familiar with.

# Examples

## Example 0 - simple one-to-one link from protein to gene

* Eutils XML: [?dbfrom=protein&db=gene&id=15718680](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680)
* sample-0.xml
* JSON-LD:
    * sample-0-1.jsonld ([playground](http://tinyurl.com/pfz5n5j))
    * sample-0-2.jsonld


## Example 1 - link from a group of identifiers

* Eutils XML: [?dbfrom=protein&db=gene&id=15718680,157427902](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680,157427902)
* sample-1.xml
* JSON-LD:
    * sample-1-1.jsonld - IDs as CURIEs ([playground])](http://tinyurl.com/oyfchkl)), or
    * sample-1-2.jsonld - IDs as bare numbers ([playground](http://tinyurl.com/o8mx5zy)) - uses embedded contexts
    * sample-1-3.jsonld


It would be nice to be able to use simple numerical ID numbers for, for example, the
objects of the *protein_gene* predicate. This should be possible, since it's clear
that, for that predicate, the targets are IDs in the *gene* database.
But, the only way I found to to this is by embedding contexts in the output document,
to redefine `@vocab`. See [this SO 
question](http://stackoverflow.com/questions/29905670/how-to-cleanly-specify-predicate-specific-uri-scopes-in-json-ld).

## Example 1.1 - basic

* Eutils XML: [?dbfrom=pubmed&id=1000,2000&linkname=pubmed_pubmed_five](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=pubmed&id=1000,2000&linkname=pubmed_pubmed_five)
* sample-1.1-1.xml
* JSON-LD:
    * sample-1.1-1.jsonld
    * sample-1.1-2.jsonld
    * sample-1.1-3.jsonld


## Example 2 - neighbor scoring

* Eutils XML: [?dbfrom=pubmed&db=pubmed&id=20210808&cmd=neighbor_score](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=pubmed&db=pubmed&id=20210808&cmd=neighbor_score)
* sample-2.xml
* JSON-LD:
    * sample-2-1.jsonld
    * sample-2-2.jsonld



## Example 3 - acheck

* Eutils XML: [?dbfrom=protein&id=15718680,157427902&cmd=acheck](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&id=15718680,157427902&cmd=acheck)
* sample-3.xml
* JSON-LD:
    * sample-3-1.jsonld

## Example 4 - neighbor history

* Eutils XML: [?dbfrom=protein&db=gene&id=15718680,157427902&cmd=neighbor_history](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680,157427902&cmd=neighbor_history)
* sample-4.xml
* JSON-LD:

## Example 5 - ncheck, lcheck

* Eutils XML: [](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi)
* sample-5.xml
* JSON-LD:

## Example 6 - llinks, llinkslib, prlinks

* Eutils XML: [](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi)
* sample-6.xml
* JSON-LD:

## Example 7 - llinkslib

* Eutils XML: [](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi)
* sample-7.xml
* JSON-LD:

## Example 8 - one to one links from protein to gene

* Eutils XML: [](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi)
* sample-8.xml
* JSON-LD:






