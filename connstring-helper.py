from pymongo import uri_parser
import sys

target = sys.argv[0]

echo f'target=${target}'

parts = pymongo.uri_parser.parse_uri(target)

## TODO: finish script to build connection
# string from the parts of a binding secret
# share this with other charts


