from BaseHTTPServer import BaseHTTPRequestHandler
import sys, getopt
import urlparse
import subprocess

class GetHandler(BaseHTTPRequestHandler):
    
    def do_400(self):
        self.send_response(400)
        self.end_headers()
        self.wfile.write("400")

    def do_GET(self):
        parsed_path = urlparse.urlparse(self.path)
        query = parsed_path.query
        if not query:
            self.do_400()
            return
        params = dict(urlparse.parse_qsl(query))

        bashCommand = "./statsz.sh " + params["name"] + " " + params["value"] + " " + params["datetime"] + " d-7_5m"
        process = subprocess.Popen(bashCommand.split(), stdout = subprocess.PIPE)

        output = process.communicate()[0]

        self.send_response(200)
        self.end_headers()
        self.wfile.write(output)
        return

def usage():
    print 'Usage: python ' + sys.argv[0] + ' --host str --port num --ssl bool'

def main(argv):
    hostname = ''
    port = 0
    use_ssl = False

    try:
        opts, args = getopt.getopt(argv, "h", ["host=", "port=", "ssl="])
        if not opts:
            print 'No options supplied'
            usage()
            sys.exit(1)
    except getopt.GetoptError:
        usage()
        sys.exit(2)
    
    for opt, arg in opts:
        if opt == '-h':
            usage()
            sys.exit()
        elif opt in ("--host"):
            hostname = arg
        elif opt in ("--port"):
            port = int(arg)
        elif opt in ("--ssl"):
            use_ssl = arg in ['True', 'true', 'yes', 'y', '1']

    from BaseHTTPServer import HTTPServer
    server = HTTPServer((hostname, port), GetHandler)
    if use_ssl:
        import ssl
        server.socket = ssl.wrap_socket(server.socket, certfile='zserver.pem', server_side=True)
    print 'Starting server use <Ctrl-C> to stop'
    print 'Hostname: %s; port: %s; use ssl: %s' % (hostname, port, use_ssl)
    server.serve_forever()

if __name__ == "__main__":
    main(sys.argv[1:])
