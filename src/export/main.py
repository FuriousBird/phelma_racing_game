from http.server import HTTPServer, SimpleHTTPRequestHandler

class HeadersHTTPRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        super().end_headers()

PORT = 8000
server = HTTPServer(("0.0.0.0", PORT), HeadersHTTPRequestHandler)
print(f"Serving at http://localhost:{PORT}")
server.serve_forever()
