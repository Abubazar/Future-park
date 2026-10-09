import sys
import asyncio
import subprocess
import importlib.util


def check():
    if importlib.util.find_spec("websockets") is None:
        print("not installed. installing")

        subprocess.check_call([
            sys.executable, "-m", "pip", "install", "websockets"
        ])
        print("installed")

check()


import websockets

async def handle_player(websocket):
    print("player connected")
    await websocket.send("you connected")

    try:
        async for message in websocket:
            print("rcieved: ", message)

            await websocket.send("server received: " + message)
    except websockets.exceptions.ConnectionClosed:
        print("player disconnected")

async def main():
    async with websockets.serve(
        handle_player,"localhost", 8080
    ):
        print("SERVER STARTED")

        await asyncio.Future()

asyncio.run(main())