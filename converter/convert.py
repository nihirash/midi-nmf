#!/usr/bin/env python3
from tkinter import filedialog, Tk
from mido import MidiFile

def convert(source, target):
    mid = MidiFile(source)
    nmf_msg = []
    accumulated_time = 0.0
    with open(target, "wb") as f:
        for msg in mid:
            accumulated_time = accumulated_time + msg.time
            if not msg.is_meta:
                ts = int(accumulated_time*50)
                if ts < 1 and len(nmf_msg) < 75:
                    for b in msg.bytes():
                        nmf_msg.append(b)
                else:
                    accumulated_time = 0.0
                    data = nmf_msg
                    nmf_msg = msg.bytes()
                    record = bytearray([len(data), ts])
                    for b in data:
                        record.append(b)
                    f.write(record)
        record = bytearray([len(nmf_msg), 0])
        for b in data:
            record.append(b)
        f.write(record)

Tk().withdraw()
source = filedialog.askopenfilename(filetypes=[("midi", "*.mid")])
if source:
    target=source[:-4]+".nmf"
    convert(source, target)