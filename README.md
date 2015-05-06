See [E-Utilities In Depth](http://www.ncbi.nlm.nih.gov/books/NBK25499/) for details
about ELink.

# Setup

Compile the DTD into an XSLT with

    dtd2xml2json --basexslt elink-json-suppl.xslt eLink_101123.dtd \
        > elink-json.xslt

Then, convert a sample file with

    xsltproc elink-json.xslt sample-0.xml


To view the original (elided) XML side-by-side with the JSON results, clone this
repo into a directory served by a web server somewhere, and load index.html.

