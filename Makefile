
TARFILE = ../rasterize-deposit-$(shell date +'%Y-%m-%d').tar.gz
# For building on my office desktop
# Rscript = ~/R/r-devel/BUILD/bin/Rscript
Rscript = Rscript

%.xml: %.cml
	# Protect HTML special chars in R code chunks
	$(Rscript) -e 't <- readLines("$*.cml"); writeLines(gsub("str>", "strong>", gsub("<rcode([^>]*)>", "<rcode\\1><![CDATA[", gsub("</rcode>", "]]></rcode>", t))), "$*.xml")'
	$(Rscript) toc.R $*.xml
	$(Rscript) bib.R $*.xml

%.Rhtml : %.xml
	# Transform to .Rhtml
	xsltproc knitr.xsl $*.xml > $*.Rhtml

%.html : %.Rhtml
	# Use knitr to produce HTML
	$(Rscript) knit.R $*.Rhtml

docker:
	sudo docker run -v $(shell pwd):/home/work/ -w /home/work --rm pmur002/rasterize make rasterize.html

web:
	make docker
	cp -r ../rasterize-report/* ~/Web/Reports/rasterize/

zip:
	make docker
	tar zcvf $(TARFILE) ./*
