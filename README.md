# Options:

* We don't have to have the accession numbers resolve to URIs.


# Examples

## Example 0 - simple, single link

* Eutils XML: [?dbfrom=protein&db=gene&id=15718680](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680)
* elink-sample-0.xml
* JSON-LD Playground: [ff98659bf516e6ec49de](http://json-ld.org/playground/#/gist/ff98659bf516e6ec49de)

## Example 1 - link from a group of identifiers

* Eutils XML: [?dbfrom=protein&db=gene&id=15718680,157427902](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680,157427902)
* elink-sample-1.xml
* JSON-LD Playground: [30e19e7a88d47a836f38](http://json-ld.org/playground/#/gist/30e19e7a88d47a836f38)

Question: do we need to have the identifier prefix on every ID inside each container in the
output?  I think, yes. I looked at this for a while, but couldn't find any way to cleanly provide
a "vocabulary URL prefix" for a given predicate. The closest I got was
[this gist](http://json-ld.org/playground/#/gist/e17eaaf164610a94c8fd), based on 
[this SO 
question](http://stackoverflow.com/questions/26633788/in-json-ld-is-it-possible-to-define-a-uri-mapping-for-a-property-value), 
but it is not right.  The URL prefix for the gene identifiers are the one global "links" vocabulary.

[This](http://json-ld.org/playground/#/gist/0948a2251589826433ae) is pretty good.

## Example 1.1

* Eutils XML: [?dbfrom=pubmed&id=1000,2000&linkname=pubmed_pubmed_five](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=pubmed&id=1000,2000&linkname=pubmed_pubmed_five)
* elink-sample-1.1.xml


## Example 2 - neighbor scoring

[This](http://json-ld.org/playground/#/gist/979fb3b4723a2d15f4ee) is a start.


## Example 3

## Example 4

## Example 5

## Example 6

## Example 7

## Example 8 - one to one links from protein to gene

http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680&id=157427902&id=119703751





