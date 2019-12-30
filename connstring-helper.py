from kubernetes import client, config
from pymongo import uri_parser
import os,sys
import urllib
from base64 import b64decode

def mode_env():
  return( os.getenv('URI'), os.getenv('USERNAME'), os.getenv('PASSWORD') )

def dp(m):
  if os.getenv("YCBS_DEBUG"):
    print(m)

def mode_secret():
  namespace=sys.argv[2]  
  secret=sys.argv[3]  
  try:
      config.load_kube_config()
  except Exception as exp:
      dp(f'trying to load incluster config exp:{exp}')
      config.load_incluster_config()
  v1 = client.CoreV1Api()
  secret = v1.read_namespaced_secret(secret,namespace)
  dp(f'secret={secret}')
  uri = b64decode(secret.data['uri']).decode()
  username = b64decode(secret.data['username']).decode()
  password = b64decode(secret.data['password']).decode()
  return (uri,username,password)

mode = sys.argv[1]   # env|secret
if mode=='env':
  (uri,u,p) = mode_env()
elif mode=='secret':
  (uri,u,p) =mode_secret()
else:
 print('connstring-helper [env|secret] <namespace> <secret_name>')

parts = uri_parser.parse_uri(uri)

parts['username']=u
parts['password']=p
dp( f"parts={parts}" )
if uri.split(':')=='mongodb+srv':
  connstr='mongodb+srv://'
else:
  connstr='mongodb://'
dp( f'connstr={connstr}' )
connstr=f"{connstr}{parts['username']}:{parts['password']}"
opts=urllib.parse.urlencode(parts['options'])
#connstr=f"{connstr}{parts['fqdn']}/{parts['db']}?{opts}"
connstr=f"{connstr}@{parts['fqdn']}/?{opts}"
print(connstr)
