PYTHON ?= python

.PHONY: all
all: clean-pyc clean-backupfiles style-check type-check test

.PHONY: style-check
style-check:
	@flake8

.PHONY: type-check
type-check:
	mypy sphinx/

.PHONY: clean
clean: clean-pyc clean-pycache clean-patchfiles clean-backupfiles clean-generated clean-testfiles clean-buildfiles clean-mypyfiles

.PHONY: clean-pyc
clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +

.PHONY: clean-pycache
clean-pycache:
	find . -name __pycache__ -exec rm -rf {} +

.PHONY: clean-patchfiles
clean-patchfiles:
	find . -name '*.orig' -exec rm -f {} +
	find . -name '*.rej' -exec rm -f {} +

.PHONY: clean-backupfiles
clean-backupfiles:
	find . -name '*~' -exec rm -f {} +
	find . -name '*.bak' -exec rm -f {} +
	find . -name '*.swp' -exec rm -f {} +
	find . -name '*.swo' -exec rm -f {} +

.PHONY: clean-generated
clean-generated:
	find . -name '.DS_Store' -exec rm -f {} +
	rm -rf Sphinx.egg-info/
	rm -rf doc/_build/
	rm -f sphinx/pycode/*.pickle
	rm -f utils/*3.py*
	rm -f utils/regression_test.js

.PHONY: clean-testfiles
clean-testfiles:
	rm -rf tests/.coverage
	rm -rf tests/build
	rm -rf .tox/
	rm -rf .cache/

.PHONY: clean-buildfiles
clean-buildfiles:
	rm -rf build

.PHONY: clean-mypyfiles
clean-mypyfiles:
	rm -rf .mypy_cache/

.PHONY: pylint
pylint:
	@pylint --rcfile utils/pylintrc sphinx

.PHONY: reindent
reindent:
	@echo "This target no longer does anything and will be removed imminently"

.PHONY: test
test:
	@cd tests; $(PYTHON) run.py --ignore py35 -v $(TEST)

.PHONY: test-async
test-async:
	@cd tests; $(PYTHON) run.py -v $(TEST)

.PHONY: covertest
covertest:
	@cd tests; $(PYTHON) run.py -v --cov=sphinx --junitxml=.junit.xml $(TEST)

.PHONY: build
build:
	@$(PYTHON) setup.py build

.PHONY: docs
docs:
ifndef target
	  $(info You need to give a provide a target variable, e.g. `make docs target=html`.)
endif
	  $(MAKE) -C doc $(target)
