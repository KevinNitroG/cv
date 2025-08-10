# Find all main-*.tex files and extract names
TEX_FILES = $(wildcard src/main-*.tex)

build/main-%.pdf: src/main-%.tex
	cd ./src && latexmk -r .latexmkrc -pdf -xelatex -jobname=tran_nguyen_thai_binh-$*-cv main-$*.tex

.PHONY: cv
cv:
	@if [ "$(filter-out cv,$(MAKECMDGOALS))" ]; then \
		$(MAKE) build/main-$(filter-out cv,$(MAKECMDGOALS)).pdf; \
	else \
		$(MAKE) $(patsubst src/main-%.tex,build/main-%.pdf,$(TEX_FILES)); \
	fi

public:
	mkdir -p public

.PHONY: page
page: public
	go run ./main.go
	cp build/*.pdf public/

.PHONY: clean
clean:
	rm -rf ./build
	rm -rf ./.tmp
	rm -rf ./public/
