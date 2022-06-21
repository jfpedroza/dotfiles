#!/usr/bin/env python3

import http
import http.server as server
import json
import subprocess
import sys
import traceback


class NotificationHandler(server.BaseHTTPRequestHandler):
    def do_POST(self):
        length = int(self.headers["Content-Length"])

        try:
            body = self.rfile.read(length)
            body = body.decode("utf-8")

            if self.headers["Content-Type"] == "application/json":
                params = json.loads(body)
            else:
                params = {"message": body}

            add_default_params(params)
        except Exception as e:
            print(f"Failed to parse the body - {body}", file=sys.stderr)
            traceback.print_exception(type(e), e, e.__traceback__)
            self.send_error(http.HTTPStatus.BAD_REQUEST)
            return

        call_command(params)

        self.send_response(http.HTTPStatus.ACCEPTED)
        self.end_headers()


def add_default_params(params):
    params["message"]

    if "title" not in params:
        params["title"] = "Notification Server"

    if "app_name" not in params:
        params["app_name"] = "notif-server"


def call_command(params):
    try:
        app_name = params["app_name"]
        title = params["title"]
        message = params["message"]
        if sys.platform == "linux":
            subprocess.check_output(
                ["notify-send", "--app-name=" + app_name, title, message])
        elif sys.platform == "darwin":
            subprocess.check_output(
                ["terminal-notifier", "-group", app_name, "-title", title, "-message", message])

    except subprocess.CalledProcessError as e:
        print(
            f"Command {e.cmd} failed due to error {e.output}", file=sys.stderr)


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 35283
    print(f"Listening on port {port}.")
    server_address = ("", port)
    httpd = server.HTTPServer(server_address, NotificationHandler)
    httpd.serve_forever()
