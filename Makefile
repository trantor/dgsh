test: sgsh
	./sgsh example/code-metrics.sh test/code-metrics/in/ >test/code-metrics/out.test
	diff -b test/code-metrics/out.ok test/code-metrics/out.test
	./sgsh example/duplicate-files.sh test/duplicate-files/ >test/duplicate-files/out.test
	diff test/duplicate-files/out.ok test/duplicate-files/out.test

sgsh: sgsh.pl
	perl -c sgsh.pl
	install sgsh.pl sgsh
