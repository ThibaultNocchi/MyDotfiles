#!/usr/bin/python3
# Inspired from https://github.com/rpieja/i3spotifystatus

import subprocess
import sys
import json

client_map = {
    "spotify": {"color": "#82c91e", "icon": ""},
    "firefox": {"color": "#fd7e14", "icon": ""},
    "jellyfin": {"color": "#aa5cc3", "icon": ""},
    "default": {"color": "#15aabf", "icon": ""}
}


def print_line(message):
    """ Non-buffered printing to stdout. """
    sys.stdout.write(message + '\n')
    sys.stdout.flush()


def read_line():
    """ Interrupted respecting reader for stdin. """
    # try reading a line, removing any extra whitespace
    try:
        line = sys.stdin.readline().strip()
        # i3status sends EOF, or an empty line
        if not line:
            sys.exit(3)
        return line
    # exit on ctrl-c
    except KeyboardInterrupt:
        sys.exit()


def is_playing():
    """ Uses playerctl to detect is something is playing """
    status = subprocess.run(
        ['playerctl', '--player=%any,firefox', 'status'], stdout=subprocess.PIPE)
    status = status.stdout.decode('utf-8')
    return status == 'Playing\n'


def get_playerctl_metadata():
    """ Retrieves playerctl metadata """
    metadata = subprocess.run(['playerctl', '--player=%any,firefox', 'metadata', '--format',
                              '{{artist}} - {{title}}'], stdout=subprocess.PIPE)
    metadata = metadata.stdout.decode('utf-8').strip()
    return metadata


def get_player():
    """ Retrieves playerctl player """
    player = subprocess.run(['playerctl', '--player=%any,firefox', 'metadata', '--format',
                             '{{playerName}}'], stdout=subprocess.PIPE)
    player = player.stdout.decode('utf-8').strip()
    if player == 'mpv':
        url = subprocess.run(
            ['playerctl', '--player=%any,firefox', 'metadata', 'xesam:url'], stdout=subprocess.PIPE)
        url = url.stdout.decode('utf-8').strip()
        if "jellyfin" in url:
            player = "jellyfin"
    if player not in client_map:
        return "default"
    return player


if __name__ == '__main__':
    # Skip the first line which contains the version header.
    print_line(read_line())

    # The second line contains the start of the infinite array.
    print_line(read_line())

    while True:

        line, prefix = read_line(), ''
        # ignore comma at start of lines
        if line.startswith(','):
            line, prefix = line[1:], ','
        if is_playing():
            j = json.loads(line)
            # insert information into the start of the json, but could be anywhere
            # CHANGE THIS LINE TO INSERT SOMETHING ELSE
            j.insert(
                0, {'color': client_map[(get_player())]['color'], 'full_text': "{} {}".format(client_map[(get_player())]['icon'], get_playerctl_metadata()), 'name': 'playerctl'})
            # and echo back new encoded json
            print_line(prefix+json.dumps(j))
        else:
            j = json.loads(line)
            print_line(prefix+json.dumps(j))
            # print_line(json.dumps(j))
