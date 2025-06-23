.PHONY: run clean

run:
	ocamlc -o hello hello.ml
	@if [ -z "$(name)" ]; then \
		./hello; \
	else \
		./hello $(name); \
	fi

run-wordfreq:
	cd wordfreq && dune exec bin/main.exe

clean:
	rm -f hello
	rm -f *.cmi

