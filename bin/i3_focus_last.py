#!/usr/bin/env python3
# From the examples in https://github.com/altdesktop/i3ipc-python

import os
import socket
import selectors
import tempfile
import threading
from argparse import ArgumentParser
import i3ipc

SOCKET_DIR = '{}/i3_focus_last.{}{}'.format(tempfile.gettempdir(), os.geteuid(),
                                            os.getenv("DISPLAY"))
SOCKET_FILE = '{}/socket'.format(SOCKET_DIR)
MAX_WIN_HISTORY = 15


class FocusWatcher:
    def __init__(self):
        self.i3 = i3ipc.Connection()
        self.i3.on('window::focus', self.on_window_focus)
        # Make a directory with permissions that restrict access to
        # the user only.
        os.makedirs(SOCKET_DIR, mode=0o700, exist_ok=True)
        self.listening_socket = socket.socket(
            socket.AF_UNIX, socket.SOCK_STREAM)
        if os.path.exists(SOCKET_FILE):
            os.remove(SOCKET_FILE)
        self.listening_socket.bind(SOCKET_FILE)
        self.listening_socket.listen(1)
        self.window_list = []
        self.window_list_lock = threading.RLock()

    def on_window_focus(self, i3conn, event):
        with self.window_list_lock:
            window_id = event.container.id
            if window_id in self.window_list:
                self.window_list.remove(window_id)
            self.window_list.insert(0, window_id)
            if len(self.window_list) > MAX_WIN_HISTORY:
                del self.window_list[MAX_WIN_HISTORY:]

    def launch_i3(self):
        self.i3.main()

    def launch_server(self):
        selector = selectors.DefaultSelector()

        def accept(sock):
            conn, _addr = sock.accept()
            selector.register(conn, selectors.EVENT_READ, read)

        def read(conn):
            data = conn.recv(1024)
            if data == b'switch':
                with self.window_list_lock:
                    tree = self.i3.get_tree()
                    windows = set(w.id for w in tree.leaves())
                    for window_id in self.window_list[1:]:
                        if window_id not in windows:
                            self.window_list.remove(window_id)
                        else:
                            self.i3.command('[con_id=%s] focus' % window_id)
                            break
            elif data == b'switch-class':
                with self.window_list_lock:
                    tree = self.i3.get_tree()
                    focused_window = tree.find_by_id(self.window_list[0])
                    assert focused_window

                    for window_id in self.window_list[1:]:
                        next_window = tree.find_by_id(window_id)
                        if next_window is None:
                            self.window_list.remove(window_id)
                        elif next_window.window_class != focused_window.window_class:
                            self.i3.command('[con_id=%s] focus' % window_id)
                            break
            elif data[:10] == b'find-last:':
                id_data = str(data[10:], 'utf-8')
                windows = [int(window) for window in id_data.split(',')]

                with self.window_list_lock:
                    last = None
                    for window_id in self.window_list:
                        if window_id in windows:
                            last = window_id
                            break

                    if not last:
                        last = windows[0]

                conn.send(bytes(str(last), 'utf-8'))
            elif not data:
                selector.unregister(conn)
                conn.close()

        selector.register(self.listening_socket, selectors.EVENT_READ, accept)

        while True:
            for key, _event in selector.select():
                callback = key.data
                callback(key.fileobj)

    def run(self):
        t_i3 = threading.Thread(target=self.launch_i3)
        t_server = threading.Thread(target=self.launch_server)
        for t in (t_i3, t_server):
            t.start()


def switch():
    client_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    client_socket.connect(SOCKET_FILE)
    client_socket.send(b'switch')
    client_socket.close()


def switch_class():
    client_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    client_socket.connect(SOCKET_FILE)
    client_socket.send(b'switch-class')
    client_socket.close()


def get_last_focused(window_ids):
    data = bytes("find-last:" + ",".join(map(str, window_ids)), 'utf-8')

    client_socket = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    client_socket.connect(SOCKET_FILE)
    client_socket.send(data)
    last_focused = int(client_socket.recv(1024))
    client_socket.close()
    return last_focused


if __name__ == '__main__':
    parser = ArgumentParser(prog='i3_focus_last.py',
                            description='''
        Focus last focused window.

        This script should be launch from the .xsessionrc without argument.

        Then you can bind this script with the `--switch` option to one of your
        i3 keybinding.
        The `--switch-class` option can be used to switch to a previously focused
        window of a different class than the current one.
        ''')
    parser.add_argument('--switch',
                        dest='switch',
                        action='store_true',
                        help='Switch to the previous window',
                        default=False)
    parser.add_argument('--switch-class',
                        dest='switch_class',
                        action='store_true',
                        help='Switch to the previous window of a different clas',
                        default=False)
    args = parser.parse_args()

    if args.switch:
        switch()
    elif args.switch_class:
        switch_class()
    else:
        focus_watcher = FocusWatcher()
        focus_watcher.run()
