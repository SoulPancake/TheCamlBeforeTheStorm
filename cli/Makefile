.PHONY: run clean

run:
	ocamlc -o hello hello.ml
	@if [ -z "$(name)" ]; then \
		./hello; \
	else \
		./hello $(name); \
	fi

clean:
	rm -f hello
	rm -f *.cmi

