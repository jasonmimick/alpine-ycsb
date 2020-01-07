from pymongo import uri_parser
import os,sys
import urllib
from base64 import b64decode

def mode_env():
  return( os.getenv('URI'), os.getenv('USERNAME'), os.getenv('PASSWORD') )

def dp(m):
  if os.getenv("YCBS_DEBUG"):
    print(m)

uri,u,p = mode_env()
if uri is None:
  print('URI env not found')
  sys.exit(1)
if u is None:
  print('USERNAME env not found')
  sys.exit(1)
if p is None:
  print('PASSWORD env not found')
  sys.exit(1)
  
dp('uri=%s' % uri)

parts = uri_parser.parse_uri(uri)

parts['username']=u
parts['password']=p
dp( 'parts=%s' % parts )
connstr='mongodb://'

dp( 'connstr=%s' % connstr )

dp( 'parts=%s' % parts )
connstr="%s%s:%s" % ( connstr, parts['username'], parts['password'])

#opts=urllib.parse.urlencode(parts['options'])
opts=urllib.urlencode(parts['options'])
hostlist=[]
for hostport in parts['nodelist']:
  hostlist.append('%s:%s' % (hostport[0],hostport[1]))

hosts=','.join(hostlist)
connstr='%s@%s/?%s' % ( connstr, hosts, opts )
print(connstr)
