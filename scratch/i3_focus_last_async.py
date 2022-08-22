#!/usr/bin/env python3

import os
import tempfile
import asyncio
from argparse import ArgumentParser
import i3ipc

SOCKET_DIR = '{}/i3_focus_last2.{}{}'.format(tempfile.gettempdir(), os.geteuid(),
                                             os.getenv("DISPLAY"))
SOCKET_FILE = '{}/socket'.format(SOCKET_DIR)

events = asyncio.Queue()
window_stack = []


def enqueue(*args):
    print("ENQUEUE", args)
    events.put_nowait(args)


async def i3_event_listener():
    while True:
        _conn, event = await events.get()
        if event.change == 'focus':
            window_stack.insert(0, event.container.id)
            print("STACK", window_stack)
        else:
            print("EVENT IS NOT FOCUS!")


async def on_unix_connect(reader, writer):
    while True:
        cmd = await reader.readline()
        cmd = cmd.strip()
        if not cmd:
            break

        if cmd == 'switch':
            print("SWITCH!!")


async def launch_i3(i3):
    i3.main()


async def launch_server():
    os.makedirs(SOCKET_DIR, mode=0o700, exist_ok=True)
    if os.path.exists(SOCKET_FILE):
        os.remove(SOCKET_FILE)

    server = await asyncio.start_unix_server(on_unix_connect, SOCKET_FILE)
    asyncio.ensure_future(i3_event_listener())
    await server.wait_closed()


def run():
    i3 = i3ipc.Connection()
    i3.on(i3ipc.Event.WINDOW_FOCUS, enqueue)

    loop = asyncio.get_event_loop()
    asyncio.ensure_future(launch_i3(i3))
    loop.run_until_complete(launch_server())


if __name__ == '__main__':
    parser = ArgumentParser(prog='i3_focus_last.py',
                            description='''
        Focus last focused window.

        This script should be launch from the .xsessionrc without argument.

        Then you can bind this script with the `--switch` option to one of your
        i3 keybinding.
        ''')
    parser.add_argument('--switch',
                        dest='switch',
                        action='store_true',
                        help='Switch to the previous window',
                        default=False)
    args = parser.parse_args()

    if not args.switch:
        print("Starting watcher")
        run()
    else:
        print("Switching")
