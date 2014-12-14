from BaseHTTPServer import BaseHTTPRequestHandler
import urlparse
import subprocess
import ssl

class GetHandler(BaseHTTPRequestHandler):
    
    def do_GET(self):
        parsed_path = urlparse.urlparse(self.path)
        query = parsed_path.query
        params = dict(urlparse.parse_qsl(query))

        bashCommand = "./statsz.sh " + params["name"] + " " + params["value"] + " " + params["datetime"] + " d-7_5m"
        process = subprocess.Popen(bashCommand.split(), stdout = subprocess.PIPE)

        output = process.communicate()[0]

        self.send_response(200)
        self.end_headers()
        self.wfile.write(output)
        return

if __name__ == '__main__':
    from BaseHTTPServer import HTTPServer
    server = HTTPServer(('localhost', 8083), GetHandler)
    server.socket = ssl.wrap_socket (server.socket, certfile='zserver.pem', server_side=True)
    print 'Starting server, use <Ctrl-C> to stop'
    server.serve_forever()
