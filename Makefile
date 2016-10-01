BUNDLE_VERSION = 1.13.1
BUNDLE = bundle _${BUNDLE_VERSION}_
BUNDLE_OPTIONS = -j 2

default: test

test: appraisal/install
	${BUNDLE} exec appraisal ${BUNDLE} exec rspec 2>&1

appraisal/install: bundle/install
	${BUNDLE} exec appraisal install

bundle/install:
	gem list -i -v ${BUNDLE_VERSION} bundler > /dev/null || gem install bundler --no-ri --no-rdoc --version=${BUNDLE_VERSION}
	${BUNDLE} check || ${BUNDLE} install ${BUNDLE_OPTIONS}

clean:
	rm -f Gemfile.lock
	rm -rf gemfiles
