See [E-Utilities In Depth](http://www.ncbi.nlm.nih.gov/books/NBK25499/) for details
about ELink.

# Setup

Compile the DTD into an XSLT with

    dtd2xml2json --basexslt elink-json-suppl.xslt eLink_101123.dtd \
        > elink-json.xslt

Then, convert a sample file with

    xsltproc elink-json.xslt sample-0.xml

# JSON-LD issues



# Samples


## Sample 0 - simple one-to-one link from protein to gene

* Eutils XML: [?dbfrom=protein&db=gene&id=15718680](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680)


## Sample 1 - link from a group of identifiers

* Eutils XML: [?dbfrom=protein&db=gene&id=15718680,157427902](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680,157427902)


## Sample 2 - basic

* Eutils XML: [?dbfrom=pubmed&id=1000,2000&linkname=pubmed_pubmed_five](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=pubmed&id=1000,2000&linkname=pubmed_pubmed_five)


## Sample 3 - neighbor scoring

* Eutils XML: [?dbfrom=pubmed&db=pubmed&id=20210808&cmd=neighbor_score](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=pubmed&db=pubmed&id=20210808&cmd=neighbor_score)


## Sample 4 - acheck

* Eutils XML: [?dbfrom=protein&id=15718680,157427902&cmd=acheck](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&id=15718680,157427902&cmd=acheck)


## Sample 5 - neighbor history

* Eutils XML: [?dbfrom=protein&db=gene&id=15718680,157427902&cmd=neighbor_history](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680,157427902&cmd=neighbor_history)


## Sample 6 - ncheck, lcheck

* Eutils XML: [?dbfrom=nuccore&id=21614549,219152114&cmd=ncheck](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=nuccore&id=21614549,219152114&cmd=ncheck)


## Sample 7 - llinks, llinkslib, prlinks

* Eutils XML: [?dbfrom=pubmed&id=19880848,19822630&cmd=llinks](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=pubmed&id=19880848,19822630&cmd=llinks)


## Sample 8 - llinkslib

* Eutils XML: [?dbfrom=pubmed&id=19880848,19822630&cmd=llinkslib](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=pubmed&id=19880848,19822630&cmd=llinkslib)


## Sample 9 - one to one links from protein to gene

* Eutils XML: [?dbfrom=protein&db=gene&id=15718680&id=157427902&id=119703751](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi?dbfrom=protein&db=gene&id=15718680&id=157427902&id=119703751)







