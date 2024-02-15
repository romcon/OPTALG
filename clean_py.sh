# Clean only python generated content only
find . -name \*.so -delete
find . -name \*.pyc -delete
find . -name \*.c -delete
find . -name \*~ -delete
find . -name __pycache__ -delete

rm -rf OPTALG.egg-info
rm -rf build
rm -rf dist