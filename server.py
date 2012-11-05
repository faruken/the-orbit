#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""

Very basic threaded HTTP Server. It guesses the mimetypes of the files as well.

"""


from __future__ import with_statement
import threading
import re
import mimetypes
import os
from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
from SocketServer import ThreadingMixIn


class ServerHandler(BaseHTTPRequestHandler):
  """It only handles `HEAD` and `GET`. I don't care about the rest. If it can't
  find the correct mimetype then we set it to `text/plain`.
  """
  
  def set_type(self, path):
    try:
      return mimetypes.guess_type(path)[0]
    except TypeError, IndexError:
      return 'text/plain'
  
  def do_HEAD(self):
    self.send_response(200)
    self.send_header('Content-Type', 'text/html; charset=UTF-8')
    self.end_headers()
  
  def do_GET(self):
    path = self.path
    curThread = threading.currentThread().getName()
    if path == '/':
      path = 'index.html'
    try:
      with open('%s%s%s' % (os.curdir, os.sep, path), 'r') as data:
        self.send_response(200)
        data_type = self.set_type(path)
        self.send_header('Content-Type', '%s; charset=UTF-8' % data_type)
        self.send_header('Access-Control-Allow-Origin', '"*"')
        self.end_headers()
        self.wfile.write(data.read())
    except IOError:
      self.send_error(404, 'File Not Found: %s' % path)
    # self.wfile.write(curThread + '\n')


class ThreadedHTTPServer(ThreadingMixIn, HTTPServer):
  pass

if __name__ == '__main__':
  server = ThreadedHTTPServer(('localhost', 8080), ServerHandler)
  try:
    print 'starting server....'
    server.serve_forever()
  except KeyboardInterrupt:
    print 'shutdown server...'
    server.server_close()
