#!/usr/bin/python

from datetime import datetime, timedelta
from bisect import bisect_left

class Event(object):
    def __init__(self, time, name):
        self.time = time
        self.name = name

quarter_names = [("{0} Uhr", 0), ("Viertel {0}", 1), ("Halb {0}", 1), ("Dreiviertel {0}", 1)]

def halfday(hour):
    return (hour + 11) % 12 + 1

def quarter_event(t):
    q = t.minute // 15
    format, delta = quarter_names[q]
    return Event(t.replace(minute=q*15), format.format(halfday(t.hour + delta)))

def nearest_event(t):
    quarter_events = [quarter_event(t + timedelta(minutes=i*15)) for i in range(5)]
    events = quarter_events
    i = bisect_left([ev.time for ev in events], t)
    if i > 0 and t - events[i-1].time < events[i].time - t: i -= 1
    return events[i]

t = datetime.now()
ev = nearest_event(t)
delta_min = t.minute - ev.time.minute
delta_min = (delta_min + 15) % 30 - 15
if delta_min != 0:
    print(abs(delta_min), "nach" if delta_min > 0 else "vor", "", end='')
print(ev.name)
