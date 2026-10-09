import sys
import asyncio
import subprocess
import importlib.util
import json
import secrets


if importlib.util.find_spec("websockets") is None:
    subprocess.check_call([
        sys.executable, "-m", "pip", "install", "websockets"
    ])

import websockets


players = {}

connections = {}


def gen_id():
    while True:
        player_id = str(
            secrets.randbelow(9_000_000_000) + 1_000_000_000
        )
        if player_id not in players:
            return player_id


async def broadcast(data, exclude=None):
    message = json.dumps(data)
    for ws in list(connections):
        if ws == exclude:
            continue
        try:
            await ws.send(message)
        except websockets.exceptions.ConnectionClosed:
            pass


async def cmd_new_player(ws,data):
    if ws in connections:
        return
    player_id = gen_id()
    name = str(data.get("name", "Player"))

    try:
        char_idx = int(data.get("charIdx",0))
    except (ValueError, TypeError):
        char_idx = 0

    others = list(players.values())

    connections[ws] = player_id
    players[player_id]={
        "id": player_id,
        "name": name,
        "charIdx": char_idx,
        "pos": {"x": 0, "y": 0}
    }
    print("New player joined: ",name," with ID: ",player_id)

    await ws.send(json.dumps({
        "type": "welcome",
        "id": player_id,
        "players": others
    }))

    await broadcast({
        "type":"new_player",
        **players[player_id]
    }, exclude=ws)


async def cmd_gone_player(ws,data):
    player_id = connections.get(ws)

    if player_id is None:
        return

    if data.get("id") != player_id:
        print("mismatch")

    players.pop(player_id,None)
    connections.pop(ws,None)

    await broadcast({
        "type":"gone_player",
        "id":player_id
    }, exclude=ws)
    print("Player left: ",player_id)



async def cmd_msg(ws,data):
    player_id = connections.get(ws)

    if player_id is None:
        return

    message = str(data.get("message",""))

    await broadcast({
        "type":"msg",
        "id":player_id,
        "message":message
    }, exclude=ws)


async def cmd_pos(ws,data):
    player_id = connections.get(ws)

    if player_id is None:
        return

    if data.get("id") != player_id:
        return

    pos = data.get("pos")

    if not isinstance(pos, dict):
        return

    try:
        x = float(pos["x"])
        y = float(pos["y"])
    except (KeyError, TypeError, ValueError):
        return

    players[player_id]["pos"] = {"x": x, "y": y}

    await broadcast({
        "type": "pos",
        "id": player_id,
        "pos": players[player_id]["pos"]
    }, exclude=ws)


#router
cmds = {
    "new_player": cmd_new_player,
    "gone_player": cmd_gone_player,
    "msg": cmd_msg,
    "pos": cmd_pos
}


async def handle_player(ws):
    print("New connection")

    try:
        async for message in ws:
            try:
                data = json.loads(message)
            except json.JSONDecodeError:
                continue

            if not isinstance(data, dict):
                continue

            command = data.get("type")
            handler = cmds.get(command)

            if handler is not None:
                await(handler(ws,data))
            else:
                print("unknown command ",command)
    except websockets.exceptions.ConnectionClosed:
        pass
    finally:
        player_id = connections.pop(ws,None)
        if player_id is not None:
            players.pop(player_id,None)

            await broadcast({
                "type":"gone_player",
                "id":player_id
            }, exclude=ws)
            print("Player left: ",player_id)


async def main():
    async with websockets.serve(
        handle_player, "localhost", 8080
    ):
        print("SERVER STARTED")
        await asyncio.Future()

        
asyncio.run(main())